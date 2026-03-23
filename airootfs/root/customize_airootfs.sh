#!/usr/bin/env bash
set -e

copy_ucode_images() {
    local ucode_dest="/boot"
    
    if [ -f "/usr/lib/firmware/intel-ucode.img" ]; then
        cp -v "/usr/lib/firmware/intel-ucode.img" "${ucode_dest}/intel-ucode.img"
    fi
    
    if [ -f "/usr/lib/firmware/amd-ucode.img" ]; then
        cp -v "/usr/lib/firmware/amd-ucode.img" "${ucode_dest}/amd-ucode.img"
    fi
}

copy_ucode_images

systemctl enable archcosta-session-detector.service 2>/dev/null || true
systemctl enable lightdm.service 2>/dev/null || true

exit 0
