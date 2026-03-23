#!/bin/bash

# ArchCosta Cloud Build Script for Ubuntu/Docker
# Usage: sudo ./cloud_build.sh [desktop] [kernel]
# Examples:
#   sudo ./cloud_build.sh xfce linux
#   sudo ./cloud_build.sh plasma linux-zen
#   sudo ./cloud_build.sh all linux-cachyos

# Default values
DESKTOP="${1:-xfce}"
KERNEL="${2:-linux}"

# Configuration
WORKDIR="/tmp/archiso-work"
OUTDIR="/tmp/archiso-out"
PROFILE_DIR="$(pwd)/profile"

# Kernel to package mapping
case "$KERNEL" in
    linux-zen)
        VMLINUZ="vmlinuz-linux-zen"
        INITRAMFS="initramfs-linux-zen.img"
        KERNEL_PKG="linux-zen"
        ;;
    linux-lts)
        VMLINUZ="vmlinuz-linux-lts"
        INITRAMFS="initramfs-linux-lts.img"
        KERNEL_PKG="linux-lts"
        ;;
    linux-cachyos)
        VMLINUZ="vmlinuz-linux-cachyos"
        INITRAMFS="initramfs-linux-cachyos.img"
        KERNEL_PKG="linux-cachyos"
        ;;
    *)
        VMLINUZ="vmlinuz-linux"
        INITRAMFS="initramfs-linux.img"
        KERNEL_PKG="linux"
        ;;
esac

# Desktop environment mapping
case "$DESKTOP" in
    plasma|kde)
        DESKTOP_NAME="plasma"
        ;;
    cinnamon)
        DESKTOP_NAME="cinnamon"
        ;;
    mate)
        DESKTOP_NAME="mate"
        ;;
    xfce)
        DESKTOP_NAME="xfce"
        ;;
    all)
        DESKTOP_NAME="all"
        ;;
    *)
        DESKTOP_NAME="$DESKTOP"
        ;;
esac

echo "--------------------------------------------------"
echo "🚀 ArchCosta Cloud Build Starting..."
echo "Desktop: $DESKTOP_NAME"
echo "Kernel: $KERNEL ($VMLINUZ)"
echo "--------------------------------------------------"

# Auto-discover local-repo folder
LOCAL_REPO_PATH="$(cd ../local-repo 2>/dev/null && pwd)"
if [ ! -d "$LOCAL_REPO_PATH" ]; then
    echo "⚠️ Warning: local-repo folder not found."
fi

# 1. Cleanup
sudo rm -rf "$WORKDIR" "$OUTDIR"
mkdir -p "$OUTDIR"

# 2. Update profile files for kernel selection
if [ "$KERNEL" != "linux" ]; then
    echo "==> Updating kernel-specific files..."
    
    # Update packages.x86_64
    sed -i 's/^linux$/'"$KERNEL_PKG"'/' packages.x86_64
    sed -i 's/^linux-headers$/'"$KERNEL_PKG"'-headers/' packages.x86_64
    
    # Update syslinux
    sed -i "s/vmlinuz-linux/$VMLINUZ/g" syslinux/syslinux.cfg
    sed -i "s/initramfs-linux.img/$INITRAMFS/g" syslinux/syslinux.cfg
    
    # Update efiboot entries
    sed -i "s|vmlinuz-linux|$VMLINUZ|g" efiboot/loader/entries/archcosta.conf
    sed -i "s|initramfs-linux.img|$INITRAMFS|g" efiboot/loader/entries/archcosta.conf
    sed -i "s|vmlinuz-linux|$VMLINUZ|g" efiboot/loader/entries/archcosta-accessibility.conf
    sed -i "s|initramfs-linux.img|$INITRAMFS|g" efiboot/loader/entries/archcosta-accessibility.conf
fi

# 3. Update desktop-specific files
if [ "$DESKTOP_NAME" != "all" ] && [ "$DESKTOP_NAME" != "xfce" ]; then
    echo "==> Updating desktop-specific files..."
    DESKTOPS=("archcosta-xfce" "archcosta-plasma" "archcosta-cinnamon" "archcosta-mate")
    CURRENT="archcosta-$DESKTOP_NAME"
    for d in "${DESKTOPS[@]}"; do
        if [ "$d" != "$CURRENT" ]; then
            sed -i "/$d/d" packages.x86_64
        fi
    done
    sed -i "s/iso_name=\"archcosta\"/iso_name=\"archcosta-$DESKTOP_NAME\"/" profiledef.sh
fi

# 4. Run mkarchiso
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
echo "Desktop: $DESKTOP_NAME"
echo "Kernel: $KERNEL"
echo "--------------------------------------------------"
ls -la "$OUTDIR"/*.iso 2>/dev/null || echo "No ISO found"
