# Load aliases last: Bash and zsh expand them while parsing function bodies.
for __dotfiles_shared_module in environment.sh fzf.sh functions.sh aliases.sh; do
  . "$HOME/.config/shell/$__dotfiles_shared_module"
done
unset __dotfiles_shared_module
