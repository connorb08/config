def git-run [args: list<string>] {
    let result = (^git -c commit.gpgsign=false ...$args | complete)
    if $result.exit_code != 0 {
        error make { msg: $"dotfiles:sync: git ($args | str join ' ') failed:\n($result.stdout)($result.stderr)" }
    }
    $result.stdout | str trim
}

def sync-checkout [] {
    for operation in [rebase-merge rebase-apply MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD BISECT_LOG] {
        let state = (git-run [rev-parse --git-path $operation] | path expand)
        if ($state | path exists) {
            error make { msg: $"dotfiles:sync: unfinished Git operation ($operation); finish or abort it before syncing" }
        }
    }

    git-run [symbolic-ref --quiet --short HEAD] | ignore
    git-run [remote get-url origin] | ignore
    # Require an upstream before committing anything; set it with git push -u.
    git-run [rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'] | ignore

    git-run [add --all] | ignore
    let staged = (^git diff --cached --quiet | complete)
    if $staged.exit_code == 1 {
        let host = (sys host | get hostname)
        let stamp = (date now | format date "%Y-%m-%d %H:%M")
        git-run [commit --quiet -m $"sync: ($host) ($stamp)"] | ignore
    } else if $staged.exit_code != 0 {
        error make { msg: $"dotfiles:sync: cannot inspect staged changes:\n($staged.stderr)" }
    }

    let pull = (^git -c commit.gpgsign=false pull --rebase | complete)
    if $pull.exit_code != 0 {
        print --stderr ($pull.stdout + $pull.stderr | str trim)
        # Abort only a rebase started by this pull, never another Git operation.
        for operation in [rebase-merge rebase-apply] {
            if (git-run [rev-parse --git-path $operation] | path expand | path exists) {
                git-run [rebase --abort] | ignore
                break
            }
        }
        error make { msg: "dotfiles:sync: pull failed; local commits are kept and nothing was pushed" }
    }
    git-run [push --quiet] | ignore
    print "dotfiles:sync: committed local changes, pulled, and pushed"
}

def main [root: path] {
    cd $root
    git-run [rev-parse --show-toplevel] | ignore
    $env.GIT_TERMINAL_PROMPT = "0"
    let ssh = ($env.GIT_SSH_COMMAND? | default "ssh")
    $env.GIT_SSH_COMMAND = $"($ssh) -o BatchMode=yes"

    let git_dir = (git-run [rev-parse --absolute-git-dir])
    let lock = ($git_dir | path join "dotfiles-sync.lock")
    let acquired = if $nu.os-info.name == "windows" {
        ^cmd /c mkdir $lock | complete
    } else {
        ^mkdir $lock | complete
    }
    if $acquired.exit_code != 0 {
        error make { msg: $"dotfiles:sync: could not acquire ($lock); another sync may be running. If it crashed, remove the empty lock directory before retrying.\n($acquired.stderr)" }
    }

    try {
        sync-checkout
    } catch {|err|
        rm $lock
        error make { msg: $err.msg }
    }
    rm $lock
}
