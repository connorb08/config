# Generated from aliases.toml by scripts/shell-aliases.nu. Do not edit.
if type -q eza
    alias ls 'eza --icons=auto --group-directories-first'
end
if type -q eza
    alias ll 'eza -l --icons=auto --group-directories-first --git'
end
if type -q eza
    alias la 'eza -la --icons=auto --group-directories-first --git'
end
if type -q eza
    alias lt 'eza --tree --level=2 --icons=auto --group-directories-first'
end
if type -q bat
    alias cat 'bat --paging=never'
end
if type -q rg
    alias grep 'rg'
end
if type -q fd
    alias find 'fd'
end
abbr -a o nvim
abbr -a g git
alias python 'python3'
alias pip 'pip3'
