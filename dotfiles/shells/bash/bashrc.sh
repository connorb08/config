# Linked to ~/.config/bash/bashrc; machine-specific startup files stay yours.
case $- in *i*) ;; *) return ;; esac
[ -n "${__dotfiles_bashrc:-}" ] && return
__dotfiles_bashrc=1

. ~/.config/shell/path.sh
command -v mise >/dev/null 2>&1 && eval "$(mise activate bash)"

. ~/.config/bash/bashrc.d/prompt.sh
. ~/.config/bash/bashrc.d/git.sh
. ~/.config/bash/bashrc.d/integrations.sh
. ~/.config/bash/bashrc.d/aliases.sh
. ~/.config/shell/common.sh
# History settings override the fallback prompt's defaults and retain hooks.
. ~/.config/bash/bashrc.d/history.sh
