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
    
    # Create live user with no password
    if ! id "live" &>/dev/null; then
        log "Creating live user..."
        useradd -m -p "" -G wheel,optical,storage,video,audio,network -s /bin/bash live
    else
        log "Live user already exists, updating groups..."
        usermod -a -G wheel,optical,storage,video,audio,network live 2>/dev/null || true
    fi
    
    # Set autologin for getty (fallback shell access)
    log "Configuring getty autologin..."
    mkdir -p /etc/systemd/system/getty@tty1.service.d
    cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'AUTOLOGIN'
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \u' --noclear --autologin live - $TERM
AUTOLOGIN
    
    # Create live user home skeleton
    log "Setting up live user home..."
    mkdir -p /home/live
    cp -a /etc/skel/. /home/live/
    chown -R live:live /home/live
    
    # Set default target to graphical
    log "Setting default target to graphical..."
    systemctl set-default graphical.target
}

# Set hostname
set_hostname() {
    log "Setting hostname..."
    echo "archcosta" > /etc/hostname
}

# Configure calamares
configure_calamares() {
    log "Configuring custom Calamares modules..."
    
    local custom_dir="/etc/calamares/custom"
    
    if [ -d "$custom_dir" ]; then
        # Move modules
        cp -f "$custom_dir/bootloader.conf" /etc/calamares/modules/ 2>/dev/null || true
        cp -f "$custom_dir/fstab.conf" /etc/calamares/modules/ 2>/dev/null || true
        cp -f "$custom_dir/partition.conf" /etc/calamares/modules/ 2>/dev/null || true
        cp -f "$custom_dir/shellprocess.conf" /etc/calamares/modules/ 2>/dev/null || true
        
        # Move scripts
        cp -f "$custom_dir/pacstrap_calamares" /etc/calamares/scripts/ 2>/dev/null || true
        chmod +x /etc/calamares/scripts/pacstrap_calamares 2>/dev/null || true
        
        # Cleanup custom dir
        rm -rf "$custom_dir"
    fi
}

# Main execution
main() {
    enable_services
    configure_live_user
    set_hostname
    configure_calamares
    
    # Compile dconf defaults if provided
    if command -v dconf >/dev/null 2>&1 && [ -d /etc/dconf/db/local.d ]; then
        log "Updating dconf databases..."
        dconf update || true
    fi
    
    log "==> ArchCosta Live ISO customization complete!"
}

main "$@"
