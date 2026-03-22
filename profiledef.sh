#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="archcosta"
iso_label="ARCHCOSTA_$(date +%Y%m%d%H%M)"
iso_publisher="ArchCosta <https://github.com/archcosta-os>"
iso_application="ArchCosta installation ISO"
iso_version="rolling"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/archcosta-installer"]="0:0:755"
  ["/usr/local/bin/archcosta-live-setup"]="0:0:755"
  ["/usr/local/bin/linexin-sound-fix-usb-dac"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
)
