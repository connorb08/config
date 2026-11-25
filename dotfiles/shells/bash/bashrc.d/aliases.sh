if [[ $- == *i* && ${TERM:-dumb} != dumb && ! ${NO_COLOR+x} ]]; then
  if ! command -v eza >/dev/null 2>&1; then
    case "$(uname -s)" in
      Darwin) alias ls='ls -G' ;;
      *) alias ls='ls --color=auto --group-directories-first' ;;
    esac
  fi
  if ! command -v rg >/dev/null 2>&1; then
    alias grep='grep --color=auto'
  fi
fi
alias l='ls -F'
