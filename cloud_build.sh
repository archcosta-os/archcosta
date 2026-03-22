#!/bin/bash

# ArchCosta Cloud Build Script for Ubuntu/Docker
# Usage: sudo ./cloud_build.sh

# Configuration
WORKDIR="/tmp/archiso-work"
OUTDIR="/tmp/archiso-out"
PROFILE_DIR="$(pwd)/profile"

echo "--------------------------------------------------"
echo "🚀 ArchCosta Cloud Build Starting..."
echo "--------------------------------------------------"

# 1. Cleanup
sudo rm -rf "$WORKDIR" "$OUTDIR"
mkdir -p "$OUTDIR"

# 2. Run mkarchiso inside a privileged Arch Linux container
# We mount the current directory into the container
docker run --privileged --rm \
    -v "$(pwd):/repo" \
    -v "$OUTDIR:/out" \
    -v "$WORKDIR:/work" \
    archlinux:latest \
    bash -c "
        pacman-key --init && \
        pacman-key --populate archlinux && \
        pacman -Syu --noconfirm archiso git curl && \
        mkarchiso -v -w /work -o /out /repo/profile/
    "

echo "--------------------------------------------------"
echo "✅ Build Finished!"
echo "ISO Location: $OUTDIR"
echo "--------------------------------------------------"
