#!/bin/bash
set -euo pipefail

# ============================================================================
# Fail-Closed Toolchain Validation Guard
# ============================================================================
REQUIRED_TOOLS=("nm" "strings" "otool" "lipo" "codesign" "plutil" "unzip" "zip")
for tool in "${REQUIRED_TOOLS[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "FATAL: Strumento di toolchain obbligatorio mancante nel PATH: $tool"
    exit 1
  fi
done

# ============================================================================
# Package Sideload-ready IPA for Guido App (Pure Flutter 3D / WebXR)
# ============================================================================
# This script centralizes packaging of the compiled Runner.app (built in Release AOT)
# into a standard iOS IPA archive (.ipa) under CocoaPods static linkage architecture.
# With static linkage (use_frameworks! :linkage => :static), all CocoaPods plugins
# are merged directly into the Runner executable, eliminating separate dynamic
# frameworks and preventing AMFI library validation crashes on physical devices.
# Frameworks/ contains only Flutter.framework, App.framework, and any native assets,
# without requiring or copying the CocoaPods plugins now statically linked into Runner.
#
# REMEDIATION PLAN (Commit 2 Hardening):
# 1. Strict Release/Archive candidate selection; explicit exclusion of Debug-iphoneos.
# 2. Strict AOT release validation guard (rejection of kernel_blob.bin, debug stubs,
#    debug dylibs, JIT snapshots vm_snapshot_data/isolate_snapshot_data).
# 3. Guarded preview/auxiliary dylib inspection via otool -l (no blind dylib deletion,
#    preventing dangling LC_LOAD_DYLIB commands and launch dyld abort crashes).
# 4. Comprehensive recursive transitive dependency resolution (otool -L) for both
#    dynamic frameworks (*.framework) and standalone dynamic libraries (*.dylib).
# 5. Fail-Fast thinning with lipo to arm64 and validation of App.framework size and arch.
# 6. Git LFS canary check to reject un-pulled pointer files in flutter_assets.
# 7. Preserved entitlements metadata during codesign (--preserve-metadata=entitlements).
# 8. Blocking per-unit codesign verification with advisory-only --deep check.
# 9. Dynamic IPA naming based on CFBundleShortVersionString and CFBundleVersion via plutil.
# ============================================================================

echo "=========================================="
echo "Step: Packaging IPA for Sideload / Distribution"
echo "=========================================="

REPO_DIR="${AC_REPOSITORY_DIR:-$(pwd)}"
OUTPUT_DIR="${AC_OUTPUT_DIR:-$REPO_DIR/build/ios/ipa}"
BUILD_NUM="${AC_BUILD_NUMBER:-30}"

cd "$REPO_DIR"

# 1. Candidate bundle selection: strictly Release or Archive builds
# Note: build/ios/iphoneos/Runner.app and build/ios/Debug-iphoneos/Runner.app are explicitly excluded to enforce Release AOT packaging
APP_PATH=""
for candidate in \
  "$REPO_DIR/build/ios/Release-iphoneos/Runner.app" \
  "$REPO_DIR/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app"; do
  if [ -d "$candidate" ]; then
    APP_PATH="$candidate"
    break
  fi
done

if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
  echo "ERROR: Runner.app not found in any standard Release/Archive output directories."
  echo "Listing build/ios directory contents:"
  ls -la "$REPO_DIR/build/ios/" 2>/dev/null || echo "build/ios does not exist"
  exit 1
fi

echo "Found Runner.app candidate at: $APP_PATH"

# ============================================================================
# AOT Release Validation Guard
# ============================================================================
# Prevents packaging debug stubs, JIT kernel_blob.bin artifacts, or debug dylibs
# that would cause dyld aborts (exit code 6 / SIGABRT) or AMFI rejection at launch.
echo "=== Validating AOT Release Bundle Integrity ==="

# Check 1: Candidate bundle path must not contain 'Debug'
if echo "$APP_PATH" | grep -qi "debug"; then
  echo "FATAL: Candidate bundle path indicates a Debug build ($APP_PATH)."
  echo "Only Release or Archive builds are permitted for packaging."
  exit 1
fi

# Check 2: Reject JIT / Debug artifacts (kernel_blob.bin)
if find "$APP_PATH" -name "kernel_blob.bin" 2>/dev/null | grep -q .; then
  echo "FATAL: Debug JIT artifact 'kernel_blob.bin' detected inside $APP_PATH."
  echo "AOT validation failed: Debug bundles are strictly forbidden for packaging and sideloading."
  exit 1
fi

# Check 3: Reject debug dynamic libraries
if [ -f "$APP_PATH/Runner.debug.dylib" ]; then
  echo "FATAL: Debug artifact 'Runner.debug.dylib' detected in $APP_PATH."
  echo "AOT validation failed: The bundle was built with Xcode debug configuration."
  exit 1
fi

# Check 4: Check Runner main binary for debug dylib load commands
if otool -L "$APP_PATH/Runner" 2>/dev/null | grep -qi "debug\.dylib"; then
  echo "FATAL: Main binary Runner references a debug dylib via load commands."
  echo "Only Release AOT builds are permitted."
  exit 1
fi

# Check 5: Validate App.framework Mach-O exists and is an AOT snapshot (not a debug stub)
APP_FRAMEWORK_BIN="$APP_PATH/Frameworks/App.framework/App"
if [ ! -f "$APP_FRAMEWORK_BIN" ]; then
  echo "FATAL: App.framework/App Mach-O binary missing from $APP_PATH/Frameworks."
  echo "A valid Flutter Release AOT bundle must contain App.framework with compiled Dart instructions."
  exit 1
fi

if [ ! -s "$APP_FRAMEWORK_BIN" ]; then
  echo "FATAL: App.framework/App is an empty file (zero bytes). Possible debug stub."
  exit 1
fi

# Check 5b: Ensure no debug JIT snapshots exist in App.framework
if [ -f "$APP_PATH/Frameworks/App.framework/flutter_assets/vm_snapshot_data" ] || \
   [ -f "$APP_PATH/Frameworks/App.framework/flutter_assets/isolate_snapshot_data" ] || \
   [ -f "$APP_PATH/Frameworks/App.framework/vm_snapshot_data" ] || \
   [ -f "$APP_PATH/Frameworks/App.framework/isolate_snapshot_data" ]; then
  echo "FATAL: Rilevati snapshot JIT di debug in App.framework."
  exit 1
fi

# Check 5c: Verify App.framework/App binary size exceeds 1 MiB (> 1048576 bytes)
APP_BIN_SIZE=$(wc -c < "$APP_FRAMEWORK_BIN" | tr -d ' ')
if [ "$APP_BIN_SIZE" -le 1048576 ]; then
  echo "FATAL: La dimensione del binario App.framework/App ($APP_BIN_SIZE bytes) è <= 1 MiB. Snapshot AOT non valido o stub di debug."
  exit 1
fi

# Check 5d: Verify lipo -archs returns exactly arm64
APP_ARCHS=$(lipo -archs "$APP_FRAMEWORK_BIN" | xargs)
if [ "$APP_ARCHS" != "arm64" ]; then
  echo "FATAL: L'architettura di App.framework/App non è arm64 (trovato: '$APP_ARCHS'). Previsto esattamente 'arm64'."
  exit 1
fi

# Check 5e: Validate Dart AOT exported symbols
if ! nm -gU "$APP_FRAMEWORK_BIN" 2>/dev/null | grep -q "kDart"; then
  if ! strings "$APP_FRAMEWORK_BIN" 2>/dev/null | grep -q "kDart"; then
    echo "FATAL: App.framework/App does not contain Dart AOT snapshot symbols. Bundle appears to be a debug stub."
    exit 1
  fi
fi

# Check 6: Canary Git LFS pointer files scan across flutter_assets
echo "=== Scanning flutter_assets for unresolved Git LFS pointers ==="
for assets_path in \
  "$APP_PATH/Frameworks/App.framework/flutter_assets" \
  "$APP_PATH/flutter_assets"; do
  if [ -d "$assets_path" ]; then
    if grep -rsq "version https://git-lfs.github.com/spec/v1" "$assets_path"; then
      echo "FATAL: Rilevati file puntatore Git LFS non scaricati negli asset: $assets_path"
      exit 1
    fi
  fi
done
echo "✅ Git LFS canary check passed: no unresolved LFS pointer files detected in assets."

echo "✅ AOT Release bundle validated successfully: $APP_PATH"

# Create Payload directory structure required by iOS IPA format
PAYLOAD_DIR="$REPO_DIR/build/ios/Payload"
rm -rf "$PAYLOAD_DIR"
mkdir -p "$PAYLOAD_DIR"

echo "Copying Runner.app into Payload/..."
cp -R "$APP_PATH" "$PAYLOAD_DIR/"
APP_DIR="$PAYLOAD_DIR/Runner.app"

# ============================================================================
# Static Linkage & Mach-O Dynamic Linkage Integrity Check
# ============================================================================
# Under CocoaPods static linkage (use_frameworks! :linkage => :static), plugin
# binaries are fused directly into the Runner executable. Frameworks/ contains
# only Flutter.framework, App.framework, and any native precompiled dynamic frameworks.
echo "=== Frameworks inside $APP_DIR/Frameworks ==="
mkdir -p "$APP_DIR/Frameworks"
ls -la "$APP_DIR/Frameworks" 2>/dev/null || true

SEARCH_DIRS=(
  "${BUILT_PRODUCTS_DIR:-}"
  "${PODS_CONFIGURATION_BUILD_DIR:-}"
  "${PODS_ROOT:-$REPO_DIR/ios/Pods}"
  "$REPO_DIR/build/ios"
  "$REPO_DIR/build"
  "$REPO_DIR/ios/Pods"
  "$APP_PATH/Frameworks"
  "$APP_PATH"
)

echo "=== Running recursive otool -L to verify Mach-O dynamic library linkages ==="
MAX_ITERATIONS=5
ITER=0
while [ $ITER -lt $MAX_ITERATIONS ]; do
  ITER=$((ITER + 1))
  NEW_COPIED=0

  # Collect Mach-O binaries in Runner.app, nested frameworks, and standalone dylibs
  BINARIES=("$APP_DIR/Runner")
  if [ -d "$APP_DIR/Frameworks" ]; then
    for fw in "$APP_DIR/Frameworks"/*.framework; do
      if [ -d "$fw" ]; then
        fw_base=$(basename "$fw" .framework)
        if [ -f "$fw/$fw_base" ]; then
          BINARIES+=("$fw/$fw_base")
        fi
      fi
    done
    for dylib in "$APP_DIR/Frameworks"/*.dylib; do
      if [ -f "$dylib" ]; then
        BINARIES+=("$dylib")
      fi
    done
  fi

  for binary in "${BINARIES[@]}"; do
    if [ -f "$binary" ]; then
      for dep in $(otool -L "$binary" 2>/dev/null | grep '@rpath' | awk '{print $1}' || true); do
        fw_name=$(echo "$dep" | grep -o '[^/]*\.framework' || true)
        if [ -n "$fw_name" ]; then
          # Dynamic framework (.framework)
          if [ ! -d "$APP_DIR/Frameworks/$fw_name" ]; then
            echo "⚠️ Dynamic framework $fw_name required by $(basename "$binary") but missing in Frameworks! Searching..."
            FOUND_FW=""
            for sdir in "${SEARCH_DIRS[@]}"; do
              if [ -n "$sdir" ] && [ -d "$sdir" ]; then
                FOUND_FW=$(find "$sdir" -name "$fw_name" -type d 2>/dev/null | head -n 1)
                if [ -n "$FOUND_FW" ] && [ -d "$FOUND_FW" ]; then
                  break
                fi
              fi
            done
            if [ -n "$FOUND_FW" ] && [ -d "$FOUND_FW" ]; then
              cp -R "$FOUND_FW" "$APP_DIR/Frameworks/"
              echo "✅ Self-healed: copied $fw_name into $APP_DIR/Frameworks/ from $FOUND_FW"
              NEW_COPIED=$((NEW_COPIED + 1))
            else
              echo "❌ Missing transitive dynamic framework: $fw_name required by $(basename "$binary")"
            fi
          fi
        else
          # Standalone dynamic library (.dylib)
          dylib_file=$(basename "$dep")
          if [ ! -f "$APP_DIR/Frameworks/$dylib_file" ]; then
            echo "⚠️ Dynamic library $dylib_file required by $(basename "$binary") but missing in Frameworks! Searching..."
            FOUND_DYLIB=""
            for sdir in "${SEARCH_DIRS[@]}"; do
              if [ -n "$sdir" ] && [ -d "$sdir" ]; then
                FOUND_DYLIB=$(find "$sdir" -name "$dylib_file" -type f 2>/dev/null | head -n 1)
                if [ -n "$FOUND_DYLIB" ] && [ -f "$FOUND_DYLIB" ]; then
                  break
                fi
              fi
            done
            if [ -n "$FOUND_DYLIB" ] && [ -f "$FOUND_DYLIB" ]; then
              cp -f "$FOUND_DYLIB" "$APP_DIR/Frameworks/"
              echo "✅ Self-healed: copied $dylib_file into $APP_DIR/Frameworks/ from $FOUND_DYLIB"
              NEW_COPIED=$((NEW_COPIED + 1))
            else
              echo "❌ Missing transitive dynamic library: $dylib_file required by $(basename "$binary")"
            fi
          fi
        fi
      done
    fi
  done

  if [ $NEW_COPIED -eq 0 ]; then
    break
  fi
done

# Strict verification pass: ensure all @rpath dependencies (*.framework and *.dylib) exist in Frameworks/
MISSING_COUNT=0
BINARIES=("$APP_DIR/Runner")
if [ -d "$APP_DIR/Frameworks" ]; then
  for fw in "$APP_DIR/Frameworks"/*.framework; do
    if [ -d "$fw" ]; then
      fw_base=$(basename "$fw" .framework)
      if [ -f "$fw/$fw_base" ]; then
        BINARIES+=("$fw/$fw_base")
      fi
    fi
  done
  for dylib in "$APP_DIR/Frameworks"/*.dylib; do
    if [ -f "$dylib" ]; then
      BINARIES+=("$dylib")
    fi
  done
fi

for binary in "${BINARIES[@]}"; do
  if [ -f "$binary" ]; then
    for dep in $(otool -L "$binary" 2>/dev/null | grep '@rpath' | awk '{print $1}' || true); do
      fw_name=$(echo "$dep" | grep -o '[^/]*\.framework' || true)
      if [ -n "$fw_name" ]; then
        if [ ! -d "$APP_DIR/Frameworks/$fw_name" ]; then
          echo "ERROR: Unresolved dynamic framework dependency: $fw_name required by $(basename "$binary")"
          MISSING_COUNT=$((MISSING_COUNT + 1))
        fi
      else
        dylib_file=$(basename "$dep")
        if [ ! -f "$APP_DIR/Frameworks/$dylib_file" ]; then
          echo "ERROR: Unresolved dynamic library dependency: $dylib_file required by $(basename "$binary")"
          MISSING_COUNT=$((MISSING_COUNT + 1))
        fi
      fi
    done
  fi
done

if [ "$MISSING_COUNT" -gt 0 ]; then
  echo "ERROR: $MISSING_COUNT dynamic dependencies (@rpath) missing in Frameworks/! Aborting to prevent instant dyld crash on device."
  exit 1
fi
echo "✅ All dynamic dependencies (@rpath) verified and present in Frameworks/."

# ============================================================================
# Thinning Simulator Slices (lipo) - Fail-Fast
# ============================================================================
echo "=== Verifying and thinning simulator architectures (lipo) ==="
ALL_MACHOS=("$APP_DIR/Runner")
if [ -d "$APP_DIR/Frameworks" ]; then
  for fw in "$APP_DIR/Frameworks"/*.framework; do
    if [ -d "$fw" ]; then
      fw_base=$(basename "$fw" .framework)
      if [ -f "$fw/$fw_base" ]; then
        ALL_MACHOS+=("$fw/$fw_base")
      fi
    fi
  done
  for dylib in "$APP_DIR/Frameworks"/*.dylib; do
    if [ -f "$dylib" ]; then
      ALL_MACHOS+=("$dylib")
    fi
  done
fi

for macho in "${ALL_MACHOS[@]}"; do
  if [ -f "$macho" ]; then
    archs=$(lipo -archs "$macho" 2>/dev/null)
    if echo "$archs" | grep -qE "x86_64|i386"; then
      if echo "$archs" | grep -q "arm64"; then
        echo "Thinning $macho to arm64 (removing simulator slices: $archs)..."
        if ! lipo -thin arm64 "$macho" -output "${macho}.arm64"; then
          echo "FATAL: lipo -thin arm64 fallito per $macho"
          exit 1
        fi
        if ! mv -f "${macho}.arm64" "$macho"; then
          echo "FATAL: Impossibile sostituire il binario $macho con la slice arm64 thinned."
          exit 1
        fi
      else
        echo "FATAL: Il binario $macho contiene slice simulatore ($archs) ma nessuna architettura arm64 per device."
        exit 1
      fi
    fi
  fi
done

# ============================================================================
# Clean Debug / Preview Artifacts (Guarded by otool -l load commands)
# ============================================================================
echo "=== Inspecting preview and auxiliary dylibs (guarded by otool -l) ==="
# NOTE: Blind deletion of dylibs (e.g. rm -f *.dylib or Runner.debug.dylib) is strictly
# avoided because if the Mach-O binary contains an LC_LOAD_DYLIB command pointing to
# a deleted file, dyld terminates the process instantly with SIGABRT (exit code 6) at launch.
# We inspect Runner's LC_LOAD_DYLIB load commands before removing any candidate dylib.
RUNNER_LC_LOAD_DYLIBS=$(otool -l "$APP_DIR/Runner" 2>/dev/null | awk '/cmd LC_LOAD_DYLIB/{flag=1;next}/cmd /{flag=0}flag' | grep "name " || true)

for dylib_path in "$APP_DIR"/*.dylib; do
  if [ -f "$dylib_path" ]; then
    dylib_name=$(basename "$dylib_path")
    if echo "$RUNNER_LC_LOAD_DYLIBS" | grep -q "$dylib_name"; then
      echo "⚠️ PRESERVING $dylib_name: Runner binary contains active LC_LOAD_DYLIB command. Removal would cause dyld abort at runtime."
    else
      echo "Safely removing unreferenced preview/auxiliary dylib: $dylib_name"
      rm -f "$dylib_path"
    fi
  fi
done
# NOTE: Flutter.framework Headers and Modules are preserved to guarantee cryptographic integrity of _CodeSignature/CodeResources

# ============================================================================
# Cryptographic Ad-Hoc Code Signing (Inside-Out) & Validation
# ============================================================================
echo "=== Applying Cryptographic Ad-Hoc Code Signing (Inside-Out) ==="
# Step 1: Sign nested dynamic frameworks and dylibs first (with preserved entitlements)
if [ -d "$APP_DIR/Frameworks" ]; then
  for fw in "$APP_DIR/Frameworks"/*.framework; do
    if [ -d "$fw" ]; then
      echo "Signing nested framework: $(basename "$fw")"
      codesign --force --sign "-" --timestamp=none --preserve-metadata=entitlements "$fw"
    fi
  done
  for dylib in "$APP_DIR/Frameworks"/*.dylib; do
    if [ -f "$dylib" ]; then
      echo "Signing nested dylib: $(basename "$dylib")"
      codesign --force --sign "-" --timestamp=none --preserve-metadata=entitlements "$dylib"
    fi
  done
fi

# Step 2: Sign the top-level Runner.app bundle
echo "Signing main application bundle: Runner.app"
codesign --force --sign "-" --timestamp=none --preserve-metadata=entitlements "$APP_DIR"

# Step 3: Per-unit blocking code signature verification
echo "=== Verifying code signatures (per-unit strict check) ==="
echo "Verifying signature for main executable ($APP_DIR/Runner)..."
if ! codesign --verify --strict "$APP_DIR/Runner"; then
  echo "FATAL: Verifica codesign fallita per l'eseguibile principale $APP_DIR/Runner."
  exit 1
fi

if [ -d "$APP_DIR/Frameworks" ]; then
  for fw in "$APP_DIR/Frameworks"/*.framework; do
    if [ -d "$fw" ]; then
      echo "Verifying signature for nested framework: $(basename "$fw")..."
      if ! codesign --verify --strict "$fw"; then
        echo "FATAL: Verifica codesign fallita per nested framework $fw."
        exit 1
      fi
    fi
  done
  for dylib in "$APP_DIR/Frameworks"/*.dylib; do
    if [ -f "$dylib" ]; then
      echo "Verifying signature for nested dylib: $(basename "$dylib")..."
      if ! codesign --verify --strict "$dylib"; then
        echo "FATAL: Verifica codesign fallita per nested dylib $dylib."
        exit 1
      fi
    fi
  done
fi
echo "✅ Per-unit codesign verification passed: all Mach-O binaries have valid signatures."

# Step 4: Advisory recursive bundle verification (--deep)
# NOTE: Kept as advisory check to prevent false positives from CocoaPods resource bundles
# with CODE_SIGNING_ALLOWED=NO, while still logging any bundle-level issues.
echo "Performing advisory recursive bundle verification (--deep)..."
codesign --verify --deep --strict "$APP_DIR" || {
  echo "WARNING: Advisory --deep codesign check reported bundle-level warnings (non-fatal, expected for unsigned resource bundles)."
}

# ============================================================================
# Package Payload into IPA Archive
# ============================================================================
# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Dynamic derivation of version and build from $APP_DIR/Info.plist using plutil
APP_VERSION=""
APP_BUILD=""
if [ -f "$APP_DIR/Info.plist" ]; then
  APP_VERSION=$(plutil -extract CFBundleShortVersionString raw -expect string "$APP_DIR/Info.plist" 2>/dev/null || true)
  APP_BUILD=$(plutil -extract CFBundleVersion raw -expect string "$APP_DIR/Info.plist" 2>/dev/null || true)
fi

APP_VERSION="${APP_VERSION:-0.1.0}"
APP_BUILD="${APP_BUILD:-${BUILD_NUM:-30}}"

IPA_NAME="Guido_v${APP_VERSION}_b${APP_BUILD}.ipa"
IPA_DEST="$OUTPUT_DIR/$IPA_NAME"

echo "Creating IPA archive: $IPA_DEST..."
cd "$REPO_DIR/build/ios"
rm -f "$IPA_DEST"
zip -qry "$IPA_DEST" Payload

# Provide canonical sideload and release aliases
cp -f "$IPA_DEST" "$OUTPUT_DIR/Guido_Release_AOT.ipa" 2>/dev/null || true
cp -f "$IPA_DEST" "$OUTPUT_DIR/Guido_iOS_Sideload.ipa" 2>/dev/null || true

# Clean up temporary Payload folder
rm -rf "$PAYLOAD_DIR"

echo "=========================================="
echo "IPA Created Successfully with Static Pods Linkage and Cryptographic Signatures Verified!"
echo "Destination: $IPA_DEST"
echo "Size: $(du -sh "$IPA_DEST" 2>/dev/null | cut -f1 || ls -lh "$IPA_DEST" | awk '{print $5}')"
echo "=========================================="
