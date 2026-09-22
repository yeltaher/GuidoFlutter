#!/bin/bash
set -euo pipefail

# ============================================================================
# UnityFramework Copy Script for Appcircle
# ============================================================================
# This script copies the built UnityFramework.framework to the correct
# location for flutter_unity_widget_2 plugin.
#
# The plugin expects the framework at:
#   ios/UnityLibrary/Frameworks/UnityFramework.framework/
#
# Usage in Appcircle:
# - Add "Custom Script" step (after Build UnityFramework)
# - Set "Execute With" to "Bash"
# - Paste this script
# ============================================================================

echo "=========================================="
echo "Step 2: Copying UnityFramework"
echo "=========================================="

# Navigate to repository root
if [ -n "${AC_REPOSITORY_DIR:-}" ]; then
  cd "$AC_REPOSITORY_DIR"
fi

# Define source and destination paths
SOURCE_PATH="ios/UnityLibrary/DerivedData/Build/Products/Release-iphoneos/UnityFramework.framework"
DEST_PATH="ios/UnityLibrary/Frameworks/UnityFramework.framework"

SOURCE_DSYM="ios/UnityLibrary/DerivedData/Build/Products/Release-iphoneos/UnityFramework.framework.dSYM"
DEST_DSYM="ios/UnityLibrary/Frameworks/UnityFramework.framework.dSYM"

# Check if source exists
if [ ! -d "$SOURCE_PATH" ]; then
  echo "ERROR: UnityFramework.framework not found at $SOURCE_PATH"
  echo ""
  echo "This usually means the Build UnityFramework step failed."
  echo "Check the previous step's logs for errors."
  echo ""
  echo "Searching for framework in DerivedData..."
  FOUND=$(find ios/UnityLibrary/DerivedData -name "UnityFramework.framework" -type d 2>/dev/null | head -1)
  
  if [ -n "$FOUND" ]; then
    echo "Found framework at: $FOUND"
    SOURCE_PATH="$FOUND"
  else
    echo "No UnityFramework.framework found in DerivedData"
    exit 1
  fi
fi

echo "Source: $SOURCE_PATH"
echo "Destination: $DEST_PATH"

# Create destination directory if it doesn't exist
mkdir -p "$(dirname "$DEST_PATH")"

# Remove old framework if it exists
if [ -d "$DEST_PATH" ]; then
  echo "Removing old UnityFramework.framework..."
  rm -rf "$DEST_PATH"
fi

# Copy the framework
echo "Copying UnityFramework.framework..."
cp -R "$SOURCE_PATH" "$DEST_PATH"

# Verify copy
if [ ! -d "$DEST_PATH" ]; then
  echo "ERROR: Failed to copy UnityFramework.framework"
  exit 1
fi

echo "=========================================="
echo "UnityFramework.framework copied successfully"
echo "=========================================="
echo ""
echo "Contents of $DEST_PATH:"
ls -la "$DEST_PATH"
echo ""

# Copy dSYM bundle if present in build folder
if [ -d "$SOURCE_DSYM" ]; then
  echo "=========================================="
  echo "Copying UnityFramework.framework.dSYM"
  echo "=========================================="
  echo "Source dSYM: $SOURCE_DSYM"
  echo "Destination dSYM: $DEST_DSYM"

  if [ -d "$DEST_DSYM" ]; then
    echo "Removing old UnityFramework.framework.dSYM..."
    rm -rf "$DEST_DSYM"
  fi

  cp -R "$SOURCE_DSYM" "$DEST_DSYM"

  if [ -d "$DEST_DSYM" ]; then
    echo "✓ UnityFramework.framework.dSYM copied successfully"
  else
    echo "WARNING: Failed to copy UnityFramework.framework.dSYM"
  fi
else
  # Search for dSYM in DerivedData if not at standard path
  FOUND_DSYM=$(find ios/UnityLibrary/DerivedData -name "UnityFramework.framework.dSYM" -type d 2>/dev/null | head -1)
  if [ -n "$FOUND_DSYM" ]; then
    echo "Found dSYM at: $FOUND_DSYM"
    if [ -d "$DEST_DSYM" ]; then
      rm -rf "$DEST_DSYM"
    fi
    cp -R "$FOUND_DSYM" "$DEST_DSYM"
    echo "✓ UnityFramework.framework.dSYM copied to $DEST_DSYM"
  else
    echo "Note: dSYM bundle not found in DerivedData (skipping dSYM copy)"
  fi
fi

# Verify key files exist
REQUIRED_FILES=(
  "UnityFramework"
  "Headers"
  "Info.plist"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -e "$DEST_PATH/$file" ]; then
    echo "✓ Found: $file"
  else
    echo "✗ Missing: $file"
  fi
done

echo ""
echo "Framework is ready for Flutter build"
