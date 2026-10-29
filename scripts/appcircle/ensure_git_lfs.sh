#!/bin/bash
set -euo pipefail

# ============================================================================
# Git LFS Verification & Assets Pull Script for Appcircle
# ============================================================================
# This script ensures Git LFS is properly configured and all large binary
# assets (e.g. video files, audio tracks) are fully pulled before build.
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

echo "=========================================="
echo "Git LFS pull completed successfully."
echo "=========================================="
exit 0
