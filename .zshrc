# zsh autocompletions setup
#
# for docker run: docker completion zsh > ~/.zsh/completion/_docker
autoload -Uz compinit
fpath=(~/.zsh/completion $fpath)
compinit

# show current git branch after username
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt prompt_subst
PROMPT='%n@%m %1~ %F{green}${vcs_info_msg_0_}%f %# '

bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
source .bashrc
export PATH="/usr/local/opt/node@20/bin:$PATH"

# Added by Windsurf
export PATH="/Users/macbookpro/.codeium/windsurf/bin:$PATH"

export PATH="/usr/local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


export ANDROID_NDK_HOME=~/Library/Android/sdk/ndk/android-ndk-r27c
export PATH=$PATH:$ANDROID_NDK_HOME

export ANDROID_HOME=$HOME/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

export JAVA_HOME="$(/usr/libexec/java_home -v17)"
export PATH="$JAVA_HOME/bin:$PATH"


export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"
export PATH="/usr/local/opt/libpcap/bin:$PATH"
export PATH="/usr/local/Cellar/mtr/0.96/sbin:$PATH"


# 1 month delay for brew auto-update
export HOMEBREW_AUTO_UPDATE_SECS=2592000
