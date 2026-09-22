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

echo "=========================================="
echo "Step 1: Building UnityFramework"
echo "=========================================="

# Navigate to repository root
if [ -n "${AC_REPOSITORY_DIR:-}" ]; then
  cd "$AC_REPOSITORY_DIR"
fi

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
