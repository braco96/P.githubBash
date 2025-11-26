#!/bin/bash
# Wrapper for GH CLI
get_repos() {
    # Forces HTTPS to avoid SSH Agent locks
    gh repo list $1 --limit 100 --no-archived --json name,url
}
