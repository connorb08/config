autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
[ -n "$LS_COLORS" ] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
setopt auto_cd interactive_comments
