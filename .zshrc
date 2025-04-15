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
