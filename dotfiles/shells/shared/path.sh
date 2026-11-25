# PATH setup shared by zsh and bash, sourced before mise is activated.
# Keep it POSIX sh.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Homebrew (Apple Silicon, Intel, Linux)
if ! command -v brew >/dev/null 2>&1; then
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$brew" ]; then
      eval "$("$brew" shellenv)"
      break
    fi
  done
  unset brew
fi

# mise is installed in ~/.local/bin
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
