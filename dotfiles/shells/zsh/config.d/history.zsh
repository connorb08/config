HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=100000
SAVEHIST=100000
setopt share_history extended_history hist_ignore_all_dups hist_ignore_space
setopt hist_reduce_blanks hist_verify
