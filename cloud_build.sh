#!/bin/bash

# ArchCosta Cloud Build Script for Ubuntu/Docker
# Usage: sudo ./cloud_build.sh

# Configuration
WORKDIR="/tmp/archiso-work"
OUTDIR="/tmp/archiso-out"
PROFILE_DIR="$(pwd)/profile"

# Auto-discover local-repo folder
# Assumes local-repo is in the parent directory of the archcosta folder
LOCAL_REPO_PATH="$(cd ../local-repo 2>/dev/null && pwd)"

if [ ! -d "$LOCAL_REPO_PATH" ]; then
    echo "⚠️ Warning: local-repo folder not found in parent directory."
    echo "The build might fail if pacman.conf requires it."
fi

echo "--------------------------------------------------"
echo "🚀 ArchCosta Cloud Build Starting..."
echo "Local Repo: ${LOCAL_REPO_PATH:-Not Found}"
echo "--------------------------------------------------"

# 1. Cleanup
sudo rm -rf "$WORKDIR" "$OUTDIR"
mkdir -p "$OUTDIR"

# 2. Run mkarchiso inside a privileged Arch Linux container
# We mount the local-repo to /repo-local inside the container
docker run --privileged --rm \
    -v "$(pwd):/repo" \
    ${LOCAL_REPO_PATH:+-v "$LOCAL_REPO_PATH:/repo-local"} \
    -v "$OUTDIR:/out" \
    -v "$WORKDIR:/work" \
    archlinux:latest \
    bash -c "
        pacman-key --init && \
        pacman-key --populate archlinux && \
        pacman -Syu --noconfirm archiso grub libisoburn git curl jq zip && \
        mkarchiso -v -w /work -o /out /repo/
    "

echo "--------------------------------------------------"
echo "✅ Build Finished!"
echo "ISO Location: $OUTDIR"
echo "--------------------------------------------------"
