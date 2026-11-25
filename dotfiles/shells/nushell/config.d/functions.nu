# Leave the shell in the directory yazi was showing when it quit.
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -f $tmp
}
