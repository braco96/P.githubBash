#!/bin/bash
clone_temp() {
    local url=$1
    local dir="TEMP_$(date +%s)"
    git clone "$url" "$dir" --quiet
    echo "$dir"
}
