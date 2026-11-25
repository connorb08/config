# Generated from aliases.toml by scripts/shell-aliases.nu. Do not edit.
if type -q eza
    alias ls 'eza --icons=auto --group-directories-first'
end
if type -q eza
    alias ll 'eza -l --icons=auto --group-directories-first --git'
end
if type -q eza
    alias la 'eza -la --icons=auto --group-directories-first --git'
end
if type -q eza
    alias lt 'eza --tree --level=2 --icons=auto --group-directories-first'
end
if type -q bat
    alias cat 'bat --paging=never'
end
if type -q rg
    alias grep 'rg'
end
if type -q fd
    alias find 'fd'
end
abbr -a o nvim
abbr -a g git
alias python 'python3'
alias pip 'pip3'
abbr -a ga git add
abbr -a gaa git add --all
abbr -a gapa git add --patch
abbr -a gau git add --update
abbr -a gav git add --verbose
abbr -a gam git am
abbr -a gama git am --abort
abbr -a gamc git am --continue
abbr -a gamscp git am --show-current-patch
abbr -a gams git am --skip
abbr -a gap git apply
abbr -a gapt git apply --3way
abbr -a gbs git bisect
abbr -a gbsb git bisect bad
abbr -a gbsg git bisect good
abbr -a gbsn git bisect new
abbr -a gbso git bisect old
abbr -a gbsr git bisect reset
abbr -a gbss git bisect start
abbr -a gbl git blame -w
abbr -a gb git branch
abbr -a gba git branch --all
abbr -a gbd git branch --delete
abbr -a gbD git branch --delete --force
abbr -a gbm git branch --move
abbr -a gbnm git branch --no-merged
abbr -a gbr git branch --remotes
abbr -a gco git checkout
abbr -a gcor git checkout --recurse-submodules
abbr -a gcb git checkout -b
abbr -a gcB git checkout -B
abbr -a gcp git cherry-pick
abbr -a gcpa git cherry-pick --abort
abbr -a gcpc git cherry-pick --continue
abbr -a gclean git clean --interactive -d
abbr -a gcl git clone --recurse-submodules
abbr -a gclf git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules
abbr -a gcam git commit --all --message
abbr -a gcas git commit --all --signoff
abbr -a gcasm git commit --all --signoff --message
abbr -a gcs git commit --gpg-sign
abbr -a gcss git commit --gpg-sign --signoff
abbr -a gcssm git commit --gpg-sign --signoff --message
abbr -a gcmsg git commit --message
abbr -a gcsm git commit --signoff --message
abbr -a gc git commit --verbose
abbr -a gca git commit --verbose --all
abbr -a gcn git commit --verbose --no-edit
abbr -a gcf git config --list
abbr -a gcfu git commit --fixup
abbr -a gd git diff
abbr -a gdca git diff --cached
abbr -a gdcw git diff --cached --word-diff
abbr -a gds git diff --staged
abbr -a gdw git diff --word-diff
abbr -a gdt git diff-tree --no-commit-id --name-only -r
abbr -a gf git fetch
abbr -a gfo git fetch origin
abbr -a gg git gui citool
abbr -a gga git gui citool --amend
abbr -a ghh git help
abbr -a glgg git log --graph
abbr -a glgga git log --graph --decorate --all
abbr -a glgm git log --graph --max-count=10
abbr -a glo git log --oneline --decorate
abbr -a glog git log --oneline --decorate --graph
abbr -a gloga git log --oneline --decorate --graph --all
abbr -a glg git log --stat
abbr -a glgp git log --stat --patch
abbr -a gm git merge
abbr -a gma git merge --abort
abbr -a gmc git merge --continue
abbr -a gmtl git mergetool --no-prompt
abbr -a gmtlvim git mergetool --no-prompt --tool=vimdiff
abbr -a gl git pull
abbr -a gpr git pull --rebase
abbr -a gprv git pull --rebase -v
abbr -a gpra git pull --rebase --autostash
abbr -a gprav git pull --rebase --autostash -v
abbr -a gp git push
abbr -a gpd git push --dry-run
abbr -a gpv git push --verbose
abbr -a gpod git push origin --delete
abbr -a gpu git push upstream
abbr -a grb git rebase
abbr -a grba git rebase --abort
abbr -a grbc git rebase --continue
abbr -a grbi git rebase --interactive
abbr -a grbo git rebase --onto
abbr -a grbs git rebase --skip
abbr -a grf git reflog
abbr -a gr git remote
abbr -a grv git remote --verbose
abbr -a gra git remote add
abbr -a grrm git remote remove
abbr -a grmv git remote rename
abbr -a grset git remote set-url
abbr -a grup git remote update
abbr -a grh git reset
abbr -a gru git reset --
abbr -a grhh git reset --hard
abbr -a grhk git reset --keep
abbr -a grhs git reset --soft
abbr -a grs git restore
abbr -a grss git restore --source
abbr -a grst git restore --staged
abbr -a grev git revert
abbr -a greva git revert --abort
abbr -a grevc git revert --continue
abbr -a grm git rm
abbr -a grmc git rm --cached
abbr -a gcount git shortlog --summary --numbered
abbr -a gsh git show
abbr -a gsps git show --pretty=short --show-signature
abbr -a gstall git stash --all
abbr -a gstaa git stash apply
abbr -a gstc git stash clear
abbr -a gstd git stash drop
abbr -a gstl git stash list
abbr -a gstp git stash pop
abbr -a gsts git stash show --patch
abbr -a gs git status
abbr -a gst git status
abbr -a gss git status --short
abbr -a gsb git status --short --branch
abbr -a gsi git submodule init
abbr -a gsu git submodule update
abbr -a gsd git svn dcommit
abbr -a gsr git svn rebase
abbr -a gsw git switch
abbr -a gswc git switch --create
abbr -a gta git tag --annotate
abbr -a gts git tag --sign
abbr -a gignore git update-index --assume-unchanged
abbr -a gunignore git update-index --no-assume-unchanged
abbr -a gwch git log --patch --abbrev-commit --pretty=medium --raw
abbr -a gwt git worktree
abbr -a gwta git worktree add
abbr -a gwtls git worktree list
abbr -a gwtmv git worktree move
abbr -a gwtrm git worktree remove
abbr -a gfa git fetch --all --tags --prune --jobs=10
abbr -a gpf git push --force-with-lease --force-if-includes
abbr -a gsta git stash push
abbr -a gstu git stash push --include-untracked
