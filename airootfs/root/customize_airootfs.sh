#!/usr/bin/env bash
# Configure live iso for ArchCosta
#
set -e -u -x
shopt -s extglob

# Set locales
[[ -f /etc/locale.gen ]] && sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# Allow Parallel Downloads in pacman
[[ -f /etc/pacman.conf ]] && sed -i "s/^#Parallel/Parallel/" /etc/pacman.conf

# Ensure [archcosta-repo] is present — hosted on GitHub Pages and works on the live system
if ! grep -q '^\[archcosta-repo\]' /etc/pacman.conf; then
cat >> /etc/pacman.conf <<'EOF'

[archcosta-repo]
SigLevel = Optional TrustAll
Server = https://archcosta-os.github.io/archcosta-repo
EOF
fi

# Un-comment mirrorlist to allow pacman to work live....
[[ -f /etc/pacman.d/mirrorlist ]] && sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# Sudo to allow no password
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers
chown -c root:root /etc/sudoers
chmod -c 0440 /etc/sudoers

# Hide gparted from application menu
sed -i '/^Categories=/a Hidden=true' /usr/share/applications/gparted.desktop

# Hostname
echo "archcosta" > /etc/hostname

# Vconsole
echo "KEYMAP=us" > /etc/vconsole.conf
echo "FONT=Lat2-Terminus16" >> /etc/vconsole.conf

# Locale
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

# Set clock to UTC
hwclock --systohc --utc

# Timezone
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime

# Target directory where systemd user service symlinks will be created
TARGET_DIR="/etc/skel/.config/systemd/user/default.target.wants"

# Source directory for official systemd user service files
UNIT_SRC="/usr/lib/systemd/user"

# List of user services to be auto-enabled at login
SERVICES=(
  "wireplumber.service"
  "pipewire.service"
  "pipewire-pulse.service"
  "xdg-user-dirs.service"
)

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Loop through the list and create symlinks for each service
# Only symlink services that actually exist to prevent broken links
for service in "${SERVICES[@]}"; do
  if [[ -f "$UNIT_SRC/$service" ]]; then
    ln -sf "$UNIT_SRC/$service" "$TARGET_DIR/$service"
  else
    echo "Warning: Service file not found: $UNIT_SRC/$service"
  fi
done

# Add live user
useradd -m -p "" -G "wheel" -s /bin/bash -g users live
chown live /home/live

# Start required systemd services
systemctl enable {pacman-init,NetworkManager,bluetooth}.service -f

# Compile dconf database for system defaults
if command -v dconf &>/dev/null; then
  dconf update
fi

# Set graphical target
systemctl set-default graphical.target
