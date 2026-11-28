set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
if not type -q brew
    for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
        if test -x $brew
            $brew shellenv fish | source
            break
        end
    end
end
fish_add_path --global $HOME/.local/bin
if test -n "$CARGO_HOME"
    fish_add_path --global "$CARGO_HOME/bin"
else
    fish_add_path --global $HOME/.cargo/bin
end
