# FIXED: Handles Root Commit and Dirty State
git_reword() {
    local p=$1; local h=$2
    # Stash
    [ -n "$(git -C "$p" status --porcelain)" ] && git -C "$p" stash push -m "Auto"
    # Root check
    if git -C "$p" rev-parse --verify "$h^" >/dev/null 2>&1; then tgt="$h^"; else tgt="--root"; fi
    
    # Shared memory hack
    export GIT_EDITOR="cat /tmp/gh_msg >"
    git -C "$p" rebase -i "$tgt" --committer-date-is-author-date
    
    # Pop
    git -C "$p" stash pop >/dev/null 2>&1
}
