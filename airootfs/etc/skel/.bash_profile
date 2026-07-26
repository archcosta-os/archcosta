# ArchCosta login shell configuration
# Starts MangoWM Wayland compositor

. $HOME/.bashrc

WindowManager=mango

# Start MangoWM on TTY1
if [[ -z $WAYLAND_DISPLAY && -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    export XDG_CURRENT_DESKTOP=$WindowManager
    export XDG_SESSION_TYPE=wayland
    exec $WindowManager
fi
