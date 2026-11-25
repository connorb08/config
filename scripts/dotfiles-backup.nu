# Snapshot every path `mise dot apply` would touch, so a forced apply can be undone.
#
#   nu scripts/dotfiles-backup.nu backup             # snapshot; prints the backup dir
#   mise dot apply --force --yes                     # deploy over the existing files
#   nu scripts/dotfiles-backup.nu restore            # undo, from the newest snapshot
#   nu scripts/dotfiles-backup.nu restore <dir>      # undo, from a specific snapshot
#
# The target list comes from `mise dot status`, so it follows the current config
# (including rc-file edits). Restore never deletes: whatever is in place at restore
# time is moved into <dir>/replaced first.

const backup_root = "~/.local/state/dotfiles-backup"

def root [] { $backup_root | path expand --no-symlink }

def home-relative [target: path] {
    let home = ($env.HOME | path expand --no-symlink)
    try { $target | path relative-to $home } catch {
        error make { msg: $"Refusing to handle a target outside ($home): ($target)" }
    }
}

def targets [repo: path] {
    let status = (^mise -C $repo dot status --json | complete)
    if $status.exit_code != 0 {
        error make { msg: $"mise dot status failed:\n($status.stderr)" }
    }
    let report = ($status.stdout | from json)
    let files = ($report.files? | default [] | get target)
    let edits = ($report.edits? | default [] | get path)
    $files ++ $edits | each {|t| $t | path expand --no-symlink } | uniq
}

def copy-preserving [from: path to: path] {
    mkdir ($to | path dirname)
    # -R recurse, -P keep symlinks as links, -p keep modes and times.
    ^cp -RPp $from $to
}

def "main backup" [] {
    let repo = ($env.FILE_PWD | path dirname)
    let list = (targets $repo)
    let dir = (root | path join (date now | format date "%Y%m%d-%H%M%S"))
    mkdir $dir
    let entries = ($list | each {|target|
        let present = ($target | path exists --no-symlink)
        if $present {
            copy-preserving $target ($dir | path join files (home-relative $target))
        }
        {target: $target, present: $present}
    })
    $entries | to json | save ($dir | path join manifest.json)
    let saved = ($entries | where present | length)
    print $"Backed up ($saved) existing paths \(($entries | length) targets\) to ($dir)"
    print $"Undo a later apply with: nu ($env.CURRENT_FILE) restore ($dir)"
}

def "main restore" [dir?: path] {
    let dir = if $dir == null {
        # Only complete snapshots: the manifest is written last.
        let snapshots = (try { ls (root) | where type == dir | sort-by name } catch { [] }
            | where {|s| $s.name | path join manifest.json | path exists })
        if ($snapshots | is-empty) { error make { msg: $"No snapshots in (root)" } }
        $snapshots | last | get name
    } else {
        $dir | path expand
    }
    let manifest = (open ($dir | path join manifest.json))
    let replaced = ($dir | path join replaced (date now | format date "%Y%m%d-%H%M%S"))
    for entry in $manifest {
        let rel = (home-relative $entry.target)
        if ($entry.target | path exists --no-symlink) {
            let aside = ($replaced | path join $rel)
            mkdir ($aside | path dirname)
            mv $entry.target $aside
        }
        if $entry.present {
            copy-preserving ($dir | path join files $rel) $entry.target
        }
    }
    print $"Restored ($manifest | where present | length) paths from ($dir)"
    print $"Whatever was in place before restoring is in ($replaced)"
}

def main [] {
    print "Usage: nu scripts/dotfiles-backup.nu backup | restore [dir]"
}
