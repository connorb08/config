def main [root: path mise_bin: path] {
    loop {
        let result = (^$mise_bin -C $root run dotfiles:sync | complete)
        if ($result.stdout | is-not-empty) { print ($result.stdout | str trim) }
        if ($result.stderr | is-not-empty) { print --stderr ($result.stderr | str trim) }
        if $result.exit_code != 0 {
            print --stderr "dotfiles:autosync: sync failed; retrying in 10 minutes"
        }
        sleep 10min
    }
}
