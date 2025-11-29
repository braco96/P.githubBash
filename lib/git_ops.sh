# BUG: This function crashes on Initial Commit
git_reword() {
    git -C "$1" rebase -i "$2^"
}
