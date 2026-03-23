#
# ~/.profile
# Executed by the command interpreter for login shells
#

# Source the .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# Set PATH to include user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set default locale if not set
[ -z "$LANG" ] && export LANG=en_US.UTF-8

# Set default terminal
[ -z "$TERM" ] && export TERM=xterm-256color

# Enable color support
export CLICOLOR=1
