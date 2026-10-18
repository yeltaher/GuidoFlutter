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

# Clean up temporary Payload folder
rm -rf "$PAYLOAD_DIR"

echo "=========================================="
echo "IPA Created Successfully!"
echo "Destination: $IPA_DEST"
echo "Size: $(du -sh "$IPA_DEST" | cut -f1)"
echo "=========================================="
