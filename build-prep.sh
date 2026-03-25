#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# This script runs during the build process before mkarchiso
# It ensures microcode is available for the bootloader

set -euo pipefail

log() {
    echo "[build-prep] $*"
}

# Copy CPU microcode to /boot for bootloader access
log "Preparing microcode for bootloader..."

if [ -f "/usr/lib/firmware/intel-ucode.img" ]; then
    log "Copying Intel microcode to /boot..."
    cp -f "/usr/lib/firmware/intel-ucode.img" "/boot/intel-ucode.img" 2>/dev/null || true
fi

if [ -f "/usr/lib/firmware/amd-ucode.img" ]; then
    log "Copying AMD microcode to /boot..."
    cp -f "/usr/lib/firmware/amd-ucode.img" "/boot/amd-ucode.img" 2>/dev/null || true
fi

log "Microcode preparation complete"
