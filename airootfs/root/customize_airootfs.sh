#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -euo pipefail

# ArchCosta customize_airootfs.sh
# This script runs during the ISO build in the airootfs environment
# It sets up the live system configuration

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "==> ArchCosta Live ISO customization starting..."

# Enable system services
enable_services() {
    log "Enabling system services..."
    
    # Network
    systemctl enable NetworkManager.service 2>/dev/null || true
    
    # Display Manager (LightDM)
    systemctl enable lightdm.service 2>/dev/null || true
    
    # Session detector
    systemctl enable archcosta-session-detector.service 2>/dev/null || true
    
    # Bluetooth (disabled by default on live)
    systemctl disable bluetooth.service 2>/dev/null || true
}

# Configure live user
configure_live_user() {
    log "Configuring live user..."
    
    # Ensure live user exists and has correct groups
    if id "live" &>/dev/null; then
        usermod -a -G wheel,audio,video,optical,storage,network,power,live "live" 2>/dev/null || true
    fi
}

# Set hostname
set_hostname() {
    log "Setting hostname..."
    echo "archcosta" > /etc/hostname
}

# Main execution
main() {
    enable_services
    configure_live_user
    set_hostname
    
    log "==> ArchCosta Live ISO customization complete!"
}

main "$@"
