#!/bin/bash
source ./lib/colors.sh
print_info "Organizing git repositories by year..."
find . -name ".git" -type d -prune | while read d; do
    YEAR=$(git -C $(dirname "$d") log -1 --format=%cd --date=format:%Y)
    mkdir -p "$YEAR" && mv "$(dirname "$d")" "$YEAR/"
done
