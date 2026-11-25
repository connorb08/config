use std/assert

def git-run [args: list<string>] {
    let result = (^git -c commit.gpgsign=false -c safe.bareRepository=all ...$args | complete)
    if $result.exit_code != 0 {
        error make { msg: $"git ($args | str join ' ') failed:\n($result.stderr)" }
    }
    $result.stdout | str trim
}

def configure [repo: path] {
    git-run [-C $repo config user.name "Sync test"] | ignore
    git-run [-C $repo config user.email "sync@example.invalid"] | ignore
}

def commit [repo: path] {
    git-run [-C $repo add --all] | ignore
    git-run [-C $repo commit -qm fixture -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"] | ignore
}

def run-sync [script: path repo: path] {
    ^$nu.current-exe --no-config-file $script $repo | complete
}

def check-tests [script: path temp: path] {
    let remote = ($temp | path join "origin.git")
    let local = ($temp | path join "local")
    let peer = ($temp | path join "peer")
    git-run [init --bare --initial-branch=main $remote] | ignore
    git-run [clone $remote $local] | ignore
    configure $local
    "base" | save ($local | path join "shared.txt")
    commit $local
    git-run [-C $local push -u origin main] | ignore
    git-run [clone $remote $peer] | ignore
    configure $peer

    "remote change" | save ($peer | path join "remote.txt")
    commit $peer
    git-run [-C $peer push] | ignore
    "local change" | save ($local | path join "local.txt")
    let success = (run-sync $script $local)
    assert equal $success.exit_code 0 $success.stderr
    assert equal (open --raw ($local | path join "remote.txt")) "remote change"
    assert equal (git-run [-C $remote show HEAD:local.txt]) "local change"
    assert not ($local | path join ".git/dotfiles-sync.lock" | path exists)
    print "PASS: commit, pull/rebase, and push"

    git-run [-C $peer pull --ff-only] | ignore
    "peer conflict" | save -f ($peer | path join "shared.txt")
    commit $peer
    git-run [-C $peer push] | ignore
    let remote_head = (git-run [-C $remote rev-parse HEAD])
    "local conflict" | save -f ($local | path join "shared.txt")
    let conflict = (run-sync $script $local)
    assert ($conflict.exit_code != 0)
    assert equal (open --raw ($local | path join "shared.txt")) "local conflict"
    assert equal (git-run [-C $local show HEAD:shared.txt]) "local conflict"
    assert equal (git-run [-C $remote rev-parse HEAD]) $remote_head
    assert not ($local | path join ".git/rebase-merge" | path exists)
    assert not ($local | path join ".git/dotfiles-sync.lock" | path exists)
    print "PASS: conflicting pull preserves local commits and does not push"

    let fresh = ($temp | path join "fresh")
    git-run [clone $remote $fresh] | ignore
    configure $fresh
    git-run [-C $fresh branch --unset-upstream] | ignore
    "uncommitted" | save ($fresh | path join "pending.txt")
    let before = (git-run [-C $fresh status --porcelain])
    let missing = (run-sync $script $fresh)
    assert ($missing.exit_code != 0)
    assert equal (git-run [-C $fresh status --porcelain]) $before
    assert not ($fresh | path join ".git/dotfiles-sync.lock" | path exists)
    print "PASS: missing upstream does not stage or commit"

    git-run [-C $fresh checkout --detach] | ignore
    let detached = (run-sync $script $fresh)
    assert ($detached.exit_code != 0)
    assert equal (git-run [-C $fresh status --porcelain]) $before
    assert not ($fresh | path join ".git/dotfiles-sync.lock" | path exists)
    git-run [-C $fresh switch main] | ignore
    print "PASS: detached HEAD does not stage or commit"

    let merge = ($fresh | path join ".git/MERGE_HEAD")
    $remote_head | save $merge
    let unfinished = (run-sync $script $fresh)
    assert ($unfinished.exit_code != 0)
    assert ($merge | path exists)
    assert equal (git-run [-C $fresh status --porcelain]) $before
    rm $merge
    print "PASS: existing Git operation is left untouched"

    let lock = ($fresh | path join ".git/dotfiles-sync.lock")
    mkdir $lock
    let locked = (run-sync $script $fresh)
    assert ($locked.exit_code != 0)
    assert ($lock | path exists)
    assert equal (git-run [-C $fresh status --porcelain]) $before
    rm $lock
    print "PASS: an existing sync lock is respected"

    git-run [-C $fresh branch --set-upstream-to=origin/main] | ignore
    git-run [-C $fresh remote set-url --push origin ($temp | path join "missing.git")] | ignore
    let failed_push = (run-sync $script $fresh)
    assert ($failed_push.exit_code != 0)
    assert equal (git-run [-C $remote rev-parse HEAD]) $remote_head
    assert equal (git-run [-C $fresh show HEAD:pending.txt]) "uncommitted"
    assert not ($lock | path exists)
    print "PASS: push failure is reported and the lock is released"
}

def main [sync_script: path] {
    let script = ($sync_script | path expand)
    let temp = (mktemp -d)
    try {
        check-tests $script $temp
    } catch {|err|
        rm --recursive $temp
        error make { msg: $err.msg }
    }
    rm --recursive $temp
}
