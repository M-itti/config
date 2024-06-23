# Change to your name, do not delete backslashes

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

#export LSCOLORS=cxgxfxexbxegedabagacad

export EDITOR='vim'

export PATH="$PATH:/home/mahdi/.local/bin"

alias python='python3.12'
alias pip='pip3'

alias bt="bluetoothctl"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias l='ls'
alias share='python3 -m http.server 9000'
alias src="source venv/bin/activate"

# g++
alias g++='clang++ -std=c++17 -O0'

#[[ $TERM != "screen" ]] && exec tmux


# personalized socks config (all_proxy added)

export all_proxy=socks5://192.168.253.241:2080
export all_proxy=socks5://192.168.253.241:2080

#unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY socks_proxy SOCKS_PROXY all_proxy ALL_PROXY

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

