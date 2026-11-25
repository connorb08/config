# Add a tool to tools.toml (the shared, synced tool list), pinned to a version,
# then lock it, refresh the global mise config copy, and install it.
#
#   nu scripts/tools-add.nu <repo> <tool> [version] [--dry-run]
#
# <tool> is anything `mise use` takes: ripgrep, aqua:owner/repo, npm:prettier, ...
# Without a version, the latest one is pinned. An existing entry is updated in
# place; a new one is inserted in alphabetical order, keeping comments.

# The [tools] table of tools.toml with `tool = "version"` added or updated.
export def add-entry [text: string tool: string version: string] {
    let key = if ($tool =~ '^[A-Za-z0-9_-]+$') { $tool } else { $tool | to json }
    let entry = $'($key) = "($version)"'
    let lines = ($text | lines)
    let start = ($lines | enumerate | where item == "[tools]" | get 0?.index)
    if $start == null {
        error make { msg: "tools.toml has no [tools] table" }
    }
    let after = ($lines | skip ($start + 1) | enumerate | where {|row| $row.item =~ '^\s*\[' } | get 0?.index)
    let end = if $after == null { $lines | length } else { $start + 1 + $after }
    let name_of = {|line|
        $line | parse --regex '^\s*"?(?<name>[^"=\s]+)"?\s*=' | get 0?.name
    }
    let body = ($lines | slice ($start + 1)..<($end))
    let existing = ($body | enumerate | where {|row| (do $name_of $row.item) == $tool } | get 0?.index)
    let new_body = if $existing != null {
        # Keep a trailing comment on the line being updated.
        let comment = ($body | get $existing | parse --regex '(?<c>\s+#.*)$' | get 0?.c | default "")
        $body | update $existing $"($entry)($comment)"
    } else {
        let before = ($body | enumerate | where {|row|
            let name = (do $name_of $row.item)
            $name != null and $name > $tool
        } | get 0?.index)
        if $before != null {
            $body | insert $before $entry
        } else {
            # After the last entry, ahead of any trailing blank lines.
            let last = ($body | enumerate | where {|row| (do $name_of $row.item) != null } | last | get index? | default (-1))
            $body | insert ($last + 1) $entry
        }
    }
    (($lines | first ($start + 1)) ++ $new_body ++ ($lines | skip $end) | str join "\n") + "\n"
}

def --wrapped run-mise [repo: path ...args: string] {
    let result = (^mise -C $repo ...$args | complete)
    if $result.exit_code != 0 {
        error make { msg: $"mise ($args | str join ' ') failed:\n($result.stderr)" }
    }
    $result.stdout | str trim
}

def main [repo: path tool: string version?: string --dry-run] {
    let repo = ($repo | path expand)
    if ($tool !~ '^[A-Za-z0-9_.:/@+-]+$') or ($tool | str contains "@") {
        error make { msg: $"'($tool)' is not a tool name; give the version as a second argument: tools:add ripgrep 16.0.0" }
    }
    let version = if ($version | default "" | is-empty) {
        let latest = (run-mise $repo latest $tool)
        if ($latest | is-empty) { error make { msg: $"mise knows no versions of ($tool)" } }
        $latest
    } else { $version }

    let file = ($repo | path join "tools.toml")
    let before = (open --raw $file)
    let after = (add-entry $before $tool $version)
    if $before == $after {
        print $"tools: ($tool) is already pinned to ($version)"
        return
    }
    if $dry_run {
        print $"tools: would pin ($tool) = \"($version)\" in tools.toml"
        return
    }
    $after | save --force --raw $file
    print $"tools: pinned ($tool) = \"($version)\" in tools.toml"

    # Lock it for every platform, refresh the global copy, install it here.
    try {
        run-mise $repo lock | ignore
        print "tools: locked in mise.lock"
        run-mise $repo dot apply --yes "~/.config/mise/config.toml" | ignore
        run-mise $repo install $"($tool)@($version)" | ignore
        print $"tools: installed ($tool)@($version); the dotfiles sync shares it with your other machines"
    } catch {|err|
        $before | save --force --raw $file
        error make { msg: $"($err.msg)\ntools.toml was put back as it was." }
    }
}
