#!/bin/sh
#MISE description="Pin a tool in the dotfiles' tools.toml, lock it and install it (any directory)"
#USAGE arg "<tool>" help="Tool to add, as for mise use: ripgrep, aqua:owner/repo, npm:prettier"
#USAGE arg "[version]" help="Version to pin (default: the latest)"
#USAGE flag "-n --dry-run" help="Show what would be pinned without changing anything"
#
# The global copy of the tools:add task: `mise dot apply` links it to
# ~/.config/mise/tasks/tools/add, so it runs from any directory. It finds the
# dotfiles checkout by following that link, wherever the repo is cloned.
set -eu
self=$(readlink -f "$0")
repo=${self%/scripts/*}
exec nu --no-config-file "$repo/scripts/tools-add.nu" "$repo" "$@"
