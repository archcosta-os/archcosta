#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge system defaults
[ -f "$sysresources" ] && xrdb -merge "$sysresources"
[ -f "$sysmodmap" ] && xmodmap "$sysmodmap"
[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

# Start D-Bus
eval $(dbus-launch --sh-syntax)

# Auto-detect session
if [ -z "$DESKTOP_SESSION" ]; then
    for session in cinnamon Plasma mate xfce gnome; do
        if [ -f "/usr/share/xsessions/${session,,}.desktop" ]; then
            DESKTOP_SESSION="$session"
            break
        fi
    done
fi

# Start appropriate desktop environment
case "$DESKTOP_SESSION" in
    cinnamon|Cinnamon)
        exec cinnamon-session
        ;;
    mate|Mate)
        exec mate-session
        ;;
    xfce|Xfce)
        exec startxfce4
        ;;
    plasma|Plasma)
        exec startplasma-x11
        ;;
    gnome|Gnome)
        exec gnome-session
        ;;
    *)
        exec startxfce4
        ;;
esac
