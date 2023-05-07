export CLICOLOR=1
# Change to your name, do not delete backslashes

export LSCOLORS=cxgxfxexbxegedabagacad

export EDITOR='vim'

alias bt="bluetoothctl"

alias ls='ls --color=auto'

export PS1='mahdi@Immortal\[\e[31m\] \w $(__git_ps1 "(%s)")\[\033[00m\] '

[[ $TERM != "screen" ]] && exec tmux


# personalized socks config (all_proxy added)

unset http_proxy
unset https_proxy
unset socks_proxy
unset all_proxy # added

unset HTTP_PROXY
unset HTTPS_PROXY
unset SOCKS_PROXY
unset ALL_PROXY  # added

