# Leave the shell in the directory yazi was showing when it quit.
if command -v yazi >/dev/null 2>&1; then
  y() {
    y_tmp=$(mktemp -t yazi-cwd.XXXXXX)
    yazi "$@" --cwd-file="$y_tmp"
    y_cwd=$(command cat -- "$y_tmp")
    [ -n "$y_cwd" ] && [ "$y_cwd" != "$PWD" ] && cd -- "$y_cwd"
    rm -f -- "$y_tmp"
    unset y_tmp y_cwd
  }
fi
