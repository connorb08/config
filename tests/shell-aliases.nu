use std/assert
use ../scripts/shell-aliases.nu render

let config = (open ($env.FILE_PWD | path join "../dotfiles/shells/shared/aliases.toml"))
let posix = (render $config posix)
let fish = (render $config fish)
let nushell = (render $config nushell)
assert ($posix | str contains "if command -v eza")
assert ($posix | str contains "alias g='git'")
assert ($fish | str contains "abbr -a g git")
assert not ($fish | str contains "alias .. ")
assert ($nushell | str contains "alias ll = ls -l")
assert ($nushell | str contains "alias cat = ^bat --paging=never")
assert not ($nushell | str contains "alias ls =")
assert not ($nushell | str contains "alias find =")

for invalid in [
    {aliases: {"g;echo": ["git"]}}
    {aliases: {g: ["git", "$(touch /tmp/unsafe)"]}}
    {aliases: {g: []}}
    {aliases: {g: "git"}}
] {
    let result = (try { render $invalid posix; false } catch { true })
    assert $result
}

# --check must detect drift without overwriting the edited generated file.
let fixture = (mktemp -d)
try {
    cp ($env.FILE_PWD | path join "../dotfiles/shells/shared/aliases.toml") $fixture
    let generator = ($env.FILE_PWD | path join "../scripts/shell-aliases.nu")
    ^$nu.current-exe --no-config-file $generator $fixture | ignore
    "drift\n" | save -f ($fixture | path join "aliases.nu")
    let result = (^$nu.current-exe --no-config-file $generator $fixture --check | complete)
    assert ($result.exit_code != 0)
    assert equal (open --raw ($fixture | path join "aliases.nu")) "drift\n"
} catch {|err|
    rm -r $fixture
    error make $err
}
rm -r $fixture

# Activating Bash's extra aliases must not pass GNU-only flags to macOS ls
# when the optional modern tools are unavailable.
if $nu.os-info.name in [macos linux] {
    let aliases = ($env.FILE_PWD | path join "../dotfiles/shells/bash/bashrc.d/aliases.sh")
    let fallback = (with-env {PATH: ["/usr/bin" "/bin"], TERM: "xterm-256color"} {
        hide-env -i NO_COLOR
        ^/bin/bash --noprofile --norc -ic 'source "$1"
ls -d .
' shell-alias-test $aliases | complete
    })
    assert equal $fallback.exit_code 0 $fallback.stderr
}
print "Shared alias rendering, validation, and drift checks passed"
