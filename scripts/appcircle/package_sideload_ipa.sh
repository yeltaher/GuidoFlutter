#!/bin/bash
set -euo pipefail

# ============================================================================
# Package Sideload-ready IPA for Guido App (Pure Flutter 3D / WebXR)
# ============================================================================
# This script packages the compiled Runner.app (built by Flutter) into a standard
# iOS IPA archive (.ipa) and places it into $AC_OUTPUT_DIR so that Appcircle's
# "Export Build Artifacts" step can automatically upload and distribute it.
#
# Suitable for sideloading with Sideloadly, AltStore, Apple Configurator,
# or enterprise/ad-hoc distribution without requiring App Store signing.
# ============================================================================

echo "=========================================="
echo "Step: Packaging IPA for Sideload / Distribution"
echo "=========================================="

REPO_DIR="${AC_REPOSITORY_DIR:-$(pwd)}"
OUTPUT_DIR="${AC_OUTPUT_DIR:-$REPO_DIR/build/ios/ipa}"
BUILD_NUM="${AC_BUILD_NUMBER:-30}"

cd "$REPO_DIR"

APP_PATH=""
for candidate in \
  "$REPO_DIR/build/ios/iphoneos/Runner.app" \
  "$REPO_DIR/build/ios/Release-iphoneos/Runner.app" \
  "$REPO_DIR/build/ios/Debug-iphoneos/Runner.app"; do
  if [ -d "$candidate" ]; then
    APP_PATH="$candidate"
    break
  fi
done

if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
  echo "ERROR: Runner.app not found in any standard output directories."
  echo "Listing build/ios directory contents:"
  ls -la "$REPO_DIR/build/ios/" 2>/dev/null || echo "build/ios does not exist"
  exit 1
fi

echo "Found Runner.app at $APP_PATH"

# ============================================================================
# Dynamic Framework and Mach-O Linkage Integrity Check
# ============================================================================
echo "=== Frameworks inside $APP_PATH/Frameworks ==="
ls -la "$APP_PATH/Frameworks" 2>/dev/null || echo "No Frameworks folder found!"

RUNNER_BIN="$APP_PATH/Runner"
if [ -f "$RUNNER_BIN" ] && command -v otool >/dev/null 2>&1; then
  echo "=== Running otool -L to verify Mach-O dynamic library linkages ==="
  otool -L "$RUNNER_BIN"

  echo "=== Verifying and Self-Healing all @rpath dynamic dependencies ==="
  MISSING_COUNT=0
  for dylib in $(otool -L "$RUNNER_BIN" | grep '@rpath' | awk '{print $1}'); do
    fw_name=$(echo "$dylib" | grep -o '[^/]*\.framework' || true)
    if [ -n "$fw_name" ]; then
      if [ ! -d "$APP_PATH/Frameworks/$fw_name" ]; then
        echo "⚠️ $fw_name required by Runner but missing in $APP_PATH/Frameworks! Running self-healing search..."
        FOUND_FW=$(find "${BUILT_PRODUCTS_DIR:-$REPO_DIR/build/ios}" "${PODS_CONFIGURATION_BUILD_DIR:-$REPO_DIR/build/ios}" "${PODS_ROOT:-$REPO_DIR/ios/Pods}" "$REPO_DIR/build/ios" -name "$fw_name" -type d 2>/dev/null | head -n 1)
        if [ -n "$FOUND_FW" ] && [ -d "$FOUND_FW" ]; then
          mkdir -p "$APP_PATH/Frameworks"
          cp -R "$FOUND_FW" "$APP_PATH/Frameworks/"
          echo "✅ Self-healed: copied $fw_name into $APP_PATH/Frameworks"
        else
          echo "❌ MISSING DYLIB: $fw_name required by Runner but could not be located anywhere!"
          MISSING_COUNT=$((MISSING_COUNT + 1))
        fi
      else
        echo "✅ Present: $fw_name"
      fi
    fi
  done

  if [ "$MISSING_COUNT" -gt 0 ]; then
    echo "ERROR: $MISSING_COUNT dynamic frameworks missing! Aborting to prevent instant dyld crash on device."
    exit 1
  fi
fi

# Create Payload directory structure required by iOS IPA format
PAYLOAD_DIR="$REPO_DIR/build/ios/Payload"
rm -rf "$PAYLOAD_DIR"
mkdir -p "$PAYLOAD_DIR"

echo "Copying Runner.app into Payload/..."
cp -R "$APP_PATH" "$PAYLOAD_DIR/"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

IPA_NAME="Guido_v0.1.0_b${BUILD_NUM}.ipa"
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
echo "IPA Created Successfully with all Pods Frameworks Verified!"
echo "Destination: $IPA_DEST"
echo "Size: $(du -sh "$IPA_DEST" | cut -f1)"
echo "=========================================="
