export CLICOLOR=1
# Change to your name, do not delete backslashes

export LSCOLORS=cxgxfxexbxegedabagacad

export EDITOR='vim'

alias grep='grep --color=auto'
alias bt="bluetoothctl"
alias ls='ls --color=auto'
alias setting="gnome-control-center"

alias pip="python3.10 -m pip"

export PS1='mahdi@Immortal\[\e[32m\] \w $(__git_ps1 "(%s)")\[\033[00m\] '

#export http_proxy=http://127.0.0.1:10809/
#export https_proxy=http://127.0.0.1:10809/

#export HTTP_PROXY=http://127.0.0.1:10809/
#export HTTPS_PROXY=http://127.0.0.1:10809/

# ignoring proxies:
export no_proxy="google.com"

unset http_proxy
unset https_proxy
unset socks_proxy
unset all_proxy # updated

unset HTTP_PROXY
unset HTTPS_PROXY
unset SOCKS_PROXY
unset ALL_PROXY  # updated


