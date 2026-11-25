# ---- history: one sqlite database shared by every open terminal, written
# after each command. It also records the directory, duration and exit code:
#   history | where cwd == $env.PWD
#   history | where exit_status != 0
$env.config.history = {
    file_format: "sqlite"
    max_size: 1_000_000
    sync_on_enter: true
    isolation: false
}
