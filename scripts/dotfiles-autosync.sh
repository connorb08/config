#!/bin/sh
# Started by the dotfiles-sync service (mise.sync.toml) through the
# ~/.local/bin/dotfiles-autosync link that `mise dot apply` creates. It finds the
# checkout from that link, so the repo can be cloned anywhere. This lives in a
# script because systemd expands $variables in a service command itself
# (launchd does not), so the command cannot hold any shell code.
set -eu
self=$(readlink -f "$0")
cd "${self%/scripts/*}"
# Services get a bare PATH; mise is in one of its usual install locations.
PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
export PATH
exec mise run dotfiles:autosync
