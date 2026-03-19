#!/usr/bin/env bash
iso_name="archcosta"
iso_label="ARCHCOSTA_SPARK"
iso_publisher="ArchCosta <https://archcosta-os.github.io>"
iso_application="ArchCosta Linux Spark"
iso_version="Spark"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/passwd"]="0:0:644"
  ["/etc/group"]="0:0:644"
  ["/etc/hostname"]="0:0:644"
  ["/etc/locale.conf"]="0:0:644"
  ["/etc/machine-id"]="0:0:444"
  ["/etc/lightdm/lightdm.conf"]="0:0:644"
  ["/root"]="0:0:750"
  ["/home/live"]="1000:1000:750"
  ["/usr/local/bin/archcosta-installer"]="0:0:755"
  ["/usr/local/bin/archcosta-live-setup"]="0:0:755"
)
