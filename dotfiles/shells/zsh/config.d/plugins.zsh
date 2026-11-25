source ~/.config/zsh/config.d/one-monokai-darker.zsh
# Syntax highlighting must be the last plugin loaded.
for plugin in zsh-autosuggestions/zsh-autosuggestions.zsh \
  zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [ -r ~/.local/share/zsh/plugins/$plugin ] && source ~/.local/share/zsh/plugins/$plugin
done
unset plugin
