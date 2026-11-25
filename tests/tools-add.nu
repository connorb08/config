use std/assert
use ../scripts/tools-add.nu add-entry

let sample = '[tools]
age = "1.3.2"
jq = "1.8.2" # json
zoxide = "0.10.0"

[tool_alias]
neovim = "aqua:neovim/neovim"
'

# A new tool lands in alphabetical order inside [tools], not in [tool_alias].
let added = (add-entry $sample "fd" "10.5.2")
assert equal ($added | lines | get 2) 'fd = "10.5.2"'
assert ($added | str contains '[tool_alias]')
assert equal ($added | lines | where $it =~ '^fd' | length) 1

# Past the last entry it goes after it, ahead of the blank line.
let last = (add-entry $sample "zzz" "1.0.0")
assert equal ($last | lines | get 4) 'zzz = "1.0.0"'
assert equal ($last | lines | get 5) ''

# An existing entry is updated in place, keeping its comment.
let updated = (add-entry $sample "jq" "1.9.0")
assert equal ($updated | lines | get 2) 'jq = "1.9.0" # json'
assert equal ($updated | lines | where $it =~ '^jq' | length) 1

# Backend names need a quoted key.
let backend = (add-entry $sample "aqua:owner/repo" "2.0.0")
assert ($backend | str contains '"aqua:owner/repo" = "2.0.0"')
# ...and a second add updates that same quoted entry.
let again = (add-entry $backend "aqua:owner/repo" "2.1.0")
assert equal ($again | lines | where $it =~ 'aqua:owner/repo' | length) 1

# The real tools.toml: re-pinning a tool to its current version changes nothing.
let real = (open --raw ($env.FILE_PWD | path join "../tools.toml"))
let jq_version = ($real | parse --regex '(?m)^jq = "(?<v>[^"]+)"' | get 0.v)
assert equal (add-entry $real "jq" $jq_version) $real
print "tools:add insert, update, quoting and no-op checks passed"
