#!/bin/bash
set -euo pipefail

# ============================================================================
# Git LFS Verification & Assets Pull Script for Appcircle
# ============================================================================
# This script ensures Git LFS is properly configured and all large binary
# assets (specifically Unity 3D data) are fully pulled before any build step.
#
# Context:
# Appcircle clones the repository with --lfs=false by default, leaving
# 130-byte text pointer files in place of large Unity binaries (e.g. 110 MB
# sharedassets8.assets.resS). Building UnityFramework with pointer files causes
# immediate runtime abort() on device.
#
# Usage in Appcircle:
# - Add "Custom Script" step BEFORE "Build UnityFramework"
# - Set "Execute With" to "Bash"
# - Run this script: bash scripts/appcircle/ensure_git_lfs.sh
# ============================================================================

echo "=========================================="
echo "Step: Ensuring Git LFS Binaries"
echo "=========================================="

# Navigate to repository root
if [ -n "${AC_REPOSITORY_DIR:-}" ]; then
  cd "$AC_REPOSITORY_DIR"
fi

echo "Repository directory: $(pwd)"

# Verify git-lfs CLI is installed in environment
if ! command -v git-lfs &> /dev/null && ! git lfs version &> /dev/null; then
  echo "ERROR: git-lfs is not installed on this build machine."
  exit 1
fi

echo "Git LFS version: $(git lfs version)"

# Configure and pull LFS objects
echo "Configuring git lfs local hooks..."
git lfs install --local

echo "Pulling all Git LFS binary assets..."
git lfs pull

# Fail-fast size verification on critical Unity binary asset
TARGET_FILE="ios/UnityLibrary/Data/sharedassets8.assets.resS"
MIN_EXPECTED_BYTES=104857600  # 100 MB in bytes
LFS_POINTER_THRESHOLD=1024     # Pointer files are ~130 bytes

echo "Verifying integrity of $TARGET_FILE..."

if [ ! -f "$TARGET_FILE" ]; then
  echo "ERROR: Critical binary asset '$TARGET_FILE' does not exist."
  echo "Available files in ios/UnityLibrary/Data/:"
  ls -lh ios/UnityLibrary/Data/ 2>/dev/null || echo "Directory missing!"
  exit 1
fi

FILE_SIZE=$(wc -c < "$TARGET_FILE" | tr -d ' ')
echo "Detected file size: $FILE_SIZE bytes"

if [ "$FILE_SIZE" -le "$LFS_POINTER_THRESHOLD" ]; then
  echo "========================================================================"
  echo "FATAL ERROR: $TARGET_FILE is only $FILE_SIZE bytes!"
  echo "This indicates an UNRESOLVED Git LFS pointer file (text stub)."
  echo "Git LFS failed to pull the actual binary blob from the remote repository."
  echo "========================================================================"
  echo "Pointer content preview:"
  head -n 5 "$TARGET_FILE" 2>/dev/null || true
  exit 1
fi

if [ "$FILE_SIZE" -lt "$MIN_EXPECTED_BYTES" ]; then
  echo "========================================================================"
  echo "FATAL ERROR: $TARGET_FILE size ($FILE_SIZE bytes) is below minimum required 100 MB."
  echo "The 3D asset binary is incomplete or corrupted."
  echo "========================================================================"
  exit 1
fi

FILE_SIZE_MB=$(( FILE_SIZE / 1048576 ))
echo "========================================================================"
echo "SUCCESS: $TARGET_FILE verified ($FILE_SIZE bytes / ~${FILE_SIZE_MB} MB)."
echo "Git LFS binaries are intact. Ready to build UnityFramework."
echo "========================================================================"
