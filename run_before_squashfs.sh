#!/usr/bin/env bash
# Run before squashfs - creates live user and configures autologin

script_path=$(readlink -f "${0%/*}")
work_dir="work"

arch_chroot() {
    arch-chroot "${script_path}/${work_dir}/x86_64/airootfs" /bin/bash -c "${1}"
}

do_merge() {

arch_chroot "$(cat << EOF

echo "##############################"
echo "# Creating live user #"
echo "##############################"

echo "---> Create live user with no password --->"
useradd -m -p "" -G wheel,optical,storage,video,audio,network -s /bin/bash live 2>/dev/null || true

echo "---> Set live user to autologin in getty --->"
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'AUTOLOGIN'
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \u' --noclear --autologin live - \$TERM
AUTOLOGIN

echo "---> Create live user home skeleton --->"
mkdir -p /home/live
cp -a /etc/skel/. /home/live/
chown -R live:live /home/live

echo "---> Set autologin for graphical session --->"
mkdir -p /etc/systemd/system/getty@tty1.service.d

echo "---> Set default target to graphical --->"
systemctl set-default graphical.target

echo "##############################"
echo "# Live user created #"
echo "##############################"

EOF
)"
}

do_merge
