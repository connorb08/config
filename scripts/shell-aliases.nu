export def render [config: record shell: string] {
    if $shell not-in [posix fish nushell] {
        error make { msg: $"Unsupported shell: ($shell)" }
    }
    let options = ($config | get -o $shell | default {})
    let excluded = ($options.excluded? | default [])
    let overrides = ($options.overrides? | default {})
    let abbreviations = ($options.abbreviations? | default [])
    let native = ($options.native? | default [])
    let optional = ($config.optional? | default [])
    mut lines = ["# Generated from aliases.toml by scripts/shell-aliases.nu. Do not edit."]

    # [git] entries are `git <args>` shortcuts; fish gets them as abbreviations.
    let plain = ($config.aliases | transpose name args | insert git false)
    let git = ($config.git? | default {} | transpose name args | insert git true
        | each {|row| $row | update args (if ($row.args | describe) =~ "^list" { ["git"] ++ $row.args } else { $row.args }) })
    let rows = ($plain ++ $git)
    let duplicates = ($rows | get name | uniq --repeated)
    if ($duplicates | is-not-empty) {
        error make { msg: $"Alias defined twice: ($duplicates | str join ', ')" }
    }

    for row in $rows {
        if $row.name !~ '^(?:[A-Za-z_][A-Za-z0-9_-]*|\.{2,3})$' {
            error make { msg: $"Invalid alias name: ($row.name)" }
        }
        let args = ($overrides | get -o $row.name | default $row.args)
        if ($args | describe) != "list<string>" or ($args | is-empty) {
            error make { msg: $"Alias ($row.name) must contain a non-empty array of command arguments" }
        }
        if ($args | any {|arg| $arg !~ '^[A-Za-z0-9_./:=+-]+$' }) {
            error make { msg: $"Alias ($row.name) arguments must be plain command tokens, not shell expressions" }
        }
        if $row.name in $excluded { continue }
        let command = ($args | str join " ")
        if $shell == "nushell" {
            let prefix = if $row.name in $native { "" } else { "^" }
            $lines ++= [$"alias ($row.name) = ($prefix)($command)"]
        } else {
            let definition = if $shell == "posix" {
                $"alias ($row.name)='($command)'"
            } else if $row.name in $abbreviations or $row.git {
                $"abbr -a ($row.name) ($command)"
            } else {
                $"alias ($row.name) '($command)'"
            }
            if $row.name in $optional {
                let condition = if $shell == "posix" {
                    $"if command -v ($args.0) >/dev/null 2>&1; then"
                } else {
                    $"if type -q ($args.0)"
                }
                let end = if $shell == "posix" { "fi" } else { "end" }
                $lines ++= [$condition $"    ($definition)" $end]
            } else {
                $lines ++= [$definition]
            }
        }
    }
    ($lines | str join "\n") + "\n"
}

def main [shared_dir: path --check] {
    let dir = ($shared_dir | path expand)
    let config = (open ($dir | path join "aliases.toml"))
    let outputs = ({posix: "aliases.sh", fish: "aliases.fish", nushell: "aliases.nu"}
        | transpose shell filename
        | each {|row| {path: ($dir | path join $row.filename), content: (render $config $row.shell)} })
    for output in $outputs {
        let matches = (($output.path | path exists) and ((open --raw $output.path) == $output.content))
        if $check and not $matches {
            error make { msg: $"Generated aliases are out of date: ($output.path). Run mise run setup:shell-aliases." }
        }
        if not $check and not $matches {
            $output.content | save --force --raw $output.path
        }
    }
    print (if $check { "Shared aliases are up to date" } else { "Shared aliases generated" })
}
