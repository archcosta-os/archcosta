set -g fish_greeting ""

# ==============================
# Basic
# ==============================
alias c='clear'
alias cat='bat'
alias e='exit'
alias reload='source ~/.config/fish/config.fish'
alias ls="eza -1h -s modified -r --icons=always --group-directories-first"

# ==============================
# Navigation
# ==============================
alias b='cd ..'
alias h='cd'
alias d='cd ~/Downloads'

# ==============================
# Arch based
# ==============================
alias pacup='sudo pacman -Syu'
alias paci='sudo pacman -S --needed'
alias pacs='pacman -Ss'
alias pacr='sudo pacman -Rns'

# ==============================
# Power control
# ==============================
alias logout='loginctl terminate-user $USER'
alias reboot='systemctl reboot'
alias off='systemctl poweroff'
alias suspend='systemctl suspend'

# ==============================
# System
# ==============================
alias grubup='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias gparted='sudo -E gparted'
alias ff='fastfetch'
alias clr='clear'

# ==============================
# Network
# ==============================
alias wifi='nmtui'
alias gc='git clone'

zoxide init fish | source

set -x VISUAL nvim
set -x EDITOR nvim
