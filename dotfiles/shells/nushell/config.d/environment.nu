$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

# Integrations are generated separately into $nu.data-dir/vendor/autoload.
use std/util "path add"
path add ($nu.home-dir | path join ".local" "bin")
if ("/opt/homebrew/bin" | path exists) { path add "/opt/homebrew/bin" }

if $nu.os-info.name != "windows" and ($env.XDG_CONFIG_HOME? | is-empty) {
    $env.XDG_CONFIG_HOME = ($nu.home-dir | path join ".config")
}
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
# Silences macOS bash's "default shell is now zsh" notice in any bash started from here.
$env.BASH_SILENCE_DEPRECATION_WARNING = "1"
# $SHELL names the shell that is running, not just the login shell.
$env.SHELL = $nu.current-exe
$env.LESS = "-FRX"
if $nu.os-info.name != "windows" {
    $env.MANPAGER = "sh -c 'col -bx | bat --language=man --plain'"
    $env.MANROFFOPT = "-c"
}
$env.FZF_DEFAULT_OPTS = "--height=40% --layout=reverse --border --color=fg:#abb2bf,bg:#191c22,hl:#da61fe,fg+:#abb2bf,bg+:#262c36,hl+:#da61fe,info:#f1bd5b,prompt:#8cc761,pointer:#ff505e,marker:#ff505e,spinner:#f1bd5b,header:#676f7d"
$env.BAT_THEME = "One Monokai Darker"
$env.EZA_CONFIG_DIR = ($nu.home-dir | path join ".config" "eza")
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"
