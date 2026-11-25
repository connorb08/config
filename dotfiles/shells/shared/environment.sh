export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS=-FRX
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
GPG_TTY=$(tty) && export GPG_TTY

# macOS bash prints "The default interactive shell is now zsh" unless this is
# already set when it starts, so every shell exports it for any bash it launches.
export BASH_SILENCE_DEPRECATION_WARNING=1

# $SHELL names the shell that is running, not just the login shell, so tools
# that start "your shell" (tmux panes, editors, `exec $SHELL`) start this one.
if [ -n "${BASH_VERSION-}" ]; then
  export SHELL="$BASH"
elif [ -n "${ZSH_VERSION-}" ]; then
  export SHELL="${commands[zsh]:-$SHELL}"
fi

if command -v eza >/dev/null 2>&1; then
  export EZA_CONFIG_DIR="$HOME/.config/eza"
fi
if command -v bat >/dev/null 2>&1; then
  export BAT_THEME="One Monokai Darker"
  export MANPAGER="sh -c 'col -bx | bat --language=man --plain'"
  export MANROFFOPT=-c
fi
