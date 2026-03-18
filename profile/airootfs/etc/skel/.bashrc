# .bashrc
export PS1='\[\e[32m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]:\[\e[33m\]\w\[\e[m\]\$ '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias htop='htop'
alias neofetch='neofetch'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rs'

# ArchCosta branding
echo -e "\e[36m"
echo "  _             _      _____          _        "
echo " / \   _ __ ___| |__  /  __ \ ___  ___| |_ __ _ "
echo "/ _ \ | '__/ __| '_ \ | /  \/  _ \/ __| __/ _\` |"
echo "/ ___ \| | | (__| | | | \__/\ (_) \__ \ || (_| |"
echo "/_/   \_\_|  \___|_| |_|\____/\___/|___/\__\__,_|"
echo -e "\e[0m"
neofetch
