# Generated from aliases.toml by scripts/shell-aliases.nu. Do not edit.
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons=auto --group-directories-first'
fi
if command -v eza >/dev/null 2>&1; then
    alias ll='eza -l --icons=auto --group-directories-first --git'
fi
if command -v eza >/dev/null 2>&1; then
    alias la='eza -la --icons=auto --group-directories-first --git'
fi
if command -v eza >/dev/null 2>&1; then
    alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
fi
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
fi
if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
fi
if command -v fd >/dev/null 2>&1; then
    alias find='fd'
fi
alias o='nvim'
alias g='git'
alias python='python3'
alias pip='pip3'
alias ..='cd ..'
alias ...='cd ../..'
