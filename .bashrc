export CLICOLOR=1
# Change to your name, do not delete backslashes

export LSCOLORS=cxgxfxexbxegedabagacad

export EDITOR='vim'

alias bt="bluetoothctl"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias l='ls --color=auto'
alias share='python3 -m http.server 9000'

export PS1='mahdi@Immortal\[\e[31m\] \w $(__git_ps1 "(%s)")\[\033[00m\] '

[[ $TERM != "screen" ]] && exec tmux


# personalized socks config (all_proxy added)


# to set proxy for v2ray
# export all_proxy=socks5://127.0.0.1:10808

unset http_proxy
unset https_proxy
unset socks_proxy
unset all_proxy # added

unset HTTP_PROXY
unset HTTPS_PROXY
unset SOCKS_PROXY
unset ALL_PROXY  # added

