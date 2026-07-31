function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # User and host
    set_color cyan
    printf '%s' $USER
    set_color normal
    echo -n '@'
    set_color cyan
    printf '%s' (hostname -s)
    set_color normal
    echo -n ':'

    # PWD
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color normal

    # Git status
    set -q __fish_git_prompt_showdirtystate
    or set -g __fish_git_prompt_showdirtystate 1
    set -q __fish_git_prompt_showuntrackedfiles
    or set -g __fish_git_prompt_showuntrackedfiles 1
    set -q __fish_git_prompt_showcolorhints
    or set -g __fish_git_prompt_showcolorhints 1
    fish_vcs_prompt '|%s'

    echo

    if not test $last_status -eq 0
        set_color red
    end

    echo -n '➤ '
    set_color normal
end
