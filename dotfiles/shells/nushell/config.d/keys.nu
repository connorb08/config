$env.config.keybindings ++= [
    {
        name: fzf_history
        modifier: control
        keycode: char_r
        mode: [emacs, vi_insert, vi_normal]
        event: {
            send: executehostcommand
            cmd: "commandline edit --replace (history | get command | reverse | uniq | str join (char -i 0) | fzf --scheme=history --read0 --no-sort --query (commandline) | str trim)"
        }
    }
    {
        name: fzf_files
        modifier: control
        keycode: char_t
        mode: [emacs, vi_insert, vi_normal]
        event: {
            send: executehostcommand
            cmd: "commandline edit --insert (fd --type f --hidden --follow --exclude .git | fzf --multi --preview 'bat --color=always --style=numbers --line-range=:200 {}' | lines | str join ' ')"
        }
    }
]
