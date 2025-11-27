#!/bin/bash
source ./lib/github_api.sh
read -p "Target User: " u
get_repos $u | jq -r '.[] | .name + " " + .url'
