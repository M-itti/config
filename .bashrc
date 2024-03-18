export CLICOLOR=1
# Change to your name, do not delete backslashes

export LSCOLORS=cxgxfxexbxegedabagacad

export EDITOR='vim'

export PATH="$PATH:/home/mahdi/.local/bin"


alias bt="bluetoothctl"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias l='ls --color=auto'
alias share='python3 -m http.server 9000'

# g++
alias g++='clang++ -std=c++17 -O0'

export PS1='mahdi@Timeless\[\e[31m\] \w $(__git_ps1 "(%s)")\[\033[00m\] '

#[[ $TERM != "screen" ]] && exec tmux


# personalized socks config (all_proxy added)

#export all_proxy=socks5://127.0.0.1:10808
#!/bin/bash

unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY socks_proxy SOCKS_PROXY all_proxy ALL_PROXY


