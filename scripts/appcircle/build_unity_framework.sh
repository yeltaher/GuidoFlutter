#!/bin/bash
set -euo pipefail

# ============================================================================
# UnityFramework Build Script for Appcircle
# ============================================================================
# This script builds the UnityFramework target from Unity-iPhone.xcodeproj
# and copies it to the correct location for flutter_unity_widget_2.
#
# Usage in Appcircle:
# - Add "Custom Script" step
# - Set "Execute With" to "Bash"
# - Paste this script
# ============================================================================
# Navigate to repository root if AC_REPOSITORY_DIR is defined
if [ -n "${AC_REPOSITORY_DIR:-}" ]; then
  cd "$AC_REPOSITORY_DIR"
fi

# ============================================================================
# Step 0: Ensure Git LFS Binaries
# ============================================================================
echo "=========================================="
echo "Step 0: Ensuring Git LFS Binaries"
echo "=========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || pwd)"

if [ -f "$SCRIPT_DIR/ensure_git_lfs.sh" ]; then
  echo "Invoking ensure_git_lfs.sh from $SCRIPT_DIR/ensure_git_lfs.sh..."
  bash "$SCRIPT_DIR/ensure_git_lfs.sh"
elif [ -f "scripts/appcircle/ensure_git_lfs.sh" ]; then
  echo "Invoking ensure_git_lfs.sh from repo relative path..."
  bash "scripts/appcircle/ensure_git_lfs.sh"
elif [ -n "${AC_REPOSITORY_DIR:-}" ] && [ -f "$AC_REPOSITORY_DIR/scripts/appcircle/ensure_git_lfs.sh" ]; then
  echo "Invoking ensure_git_lfs.sh from \$AC_REPOSITORY_DIR..."
  bash "$AC_REPOSITORY_DIR/scripts/appcircle/ensure_git_lfs.sh"
else
  echo "WARNING: ensure_git_lfs.sh not found. Running direct fallback git lfs commands..."
  git lfs install --local || true
  git lfs pull
fi

echo "=========================================="
echo "Step 1: Building UnityFramework"
echo "=========================================="

# Check if Unity-iPhone.xcodeproj exists
if [ ! -d "ios/UnityLibrary/Unity-iPhone.xcodeproj" ]; then
  echo "ERROR: Unity-iPhone.xcodeproj not found at ios/UnityLibrary/"
  echo "Available contents of ios/UnityLibrary:"
  ls -la ios/UnityLibrary/ 2>/dev/null || echo "Directory not found"
  exit 1
fi

echo "Found Unity-iPhone.xcodeproj"
echo "Building UnityFramework target with dSYM debugging symbols..."

# Build UnityFramework
# - Use iphoneos SDK for device builds
# - Use Release configuration
# - Generate full dSYM debug symbols for symbolication
# - Disable code signing (Flutter/Xcode will handle it later)
# - Use derivedDataPath to keep build artifacts organized
xcodebuild -project ios/UnityLibrary/Unity-iPhone.xcodeproj \
  -target UnityFramework \
  -sdk iphoneos \
  -configuration Release \
  -derivedDataPath ios/UnityLibrary/DerivedData \
  DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \
  GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  2>&1 | tail -100

# Check if build succeeded
if [ ${PIPESTATUS[0]} -ne 0 ]; then
  echo "ERROR: UnityFramework build failed"
  echo "Check the build logs above for details"
  exit 1
fi

echo "=========================================="
echo "UnityFramework build completed successfully"
echo "=========================================="

# Verify the framework and dSYM were built
FRAMEWORK_PATH="ios/UnityLibrary/DerivedData/Build/Products/Release-iphoneos/UnityFramework.framework"
DSYM_PATH="ios/UnityLibrary/DerivedData/Build/Products/Release-iphoneos/UnityFramework.framework.dSYM"

if [ -d "$FRAMEWORK_PATH" ]; then
  echo "UnityFramework.framework found at: $FRAMEWORK_PATH"
  echo "Contents:"
  ls -la "$FRAMEWORK_PATH"
else
  echo "WARNING: UnityFramework.framework not found at expected path"
  echo "Searching for framework in DerivedData..."
  find ios/UnityLibrary/DerivedData -name "*.framework" -type d 2>/dev/null
fi

if [ -d "$DSYM_PATH" ]; then
  echo "✓ UnityFramework.framework.dSYM found at: $DSYM_PATH"
else
  echo "WARNING: UnityFramework.framework.dSYM not found at expected path"
fi
