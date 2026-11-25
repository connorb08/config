# The only auto-loaded conf.d file; modules live outside fish's conf.d.
source $HOME/.config/fish/dotfiles/path.fish
type -q mise; and mise activate fish | source

if status is-interactive
    for module in environment theme fzf functions integrations
        source $HOME/.config/fish/dotfiles/$module.fish
    end
    source $HOME/.config/shell/aliases.fish
end
