#!/bin/bash
# =====================================================
# GITHUB VERSE MANAGER - THE FINAL TOOL
# =====================================================
VERDE='\033[1;32m'; AZUL='\033[1;34m'; NC='\033[0m'
ROJO='\033[1;31m'; MAGENTA='\033[1;35m'; CYAN='\033[1;36m'

declare -a P_N; declare -a P_U; TARGET=""

editar() {
    p=$1; h=$2; m=$3
    echo -e "${MAGENTA}EDIT:${NC} $h ($m)"; read -p "New Msg: " n; [ -z "$n" ] && return
    
    local st=false; [ -n "$(git -C "$p" status --porcelain)" ] && { git -C "$p" stash push; st=true; }
    
    # Logic Phase 8 (Root Fix)
    git -C "$p" rev-parse --verify "$h^" >/dev/null 2>&1 && t="$h^" || t="--root"
    
    echo "$n" > "/tmp/msg"
    export GIT_SEQUENCE_EDITOR="sed -i 's/^pick $h/reword $h/'"
    export GIT_EDITOR="cat /tmp/msg >"
    
    if git -C "$p" rebase -i $t --committer-date-is-author-date >/dev/null 2>&1; then
        echo -e "${VERDE}Local OK.${NC}"
        read -p "PUSH FORCE to ${TARGET}? (s/n): " r
        [[ "$r" == "s" ]] && { git -C "$p" push --force origin HEAD || echo "${ROJO}Error.${NC}"; }
    else echo "${ROJO}Rebase Fail.${NC}"; git -C "$p" rebase --abort; fi
    
    unset GIT_SEQUENCE_EDITOR GIT_EDITOR; rm -f "/tmp/msg"
    [ "$st" = true ] && git -C "$p" stash pop
}

manager() {
    u=$1; n=$2; tmp="./TEMP_${u}_${n}"; rm -rf "$tmp"
    echo -e "${CYAN}Clone $n...${NC}"; git clone "$u" "$tmp" --quiet || return
    
    while true; do
        clear; echo -e "${AZUL}PROJECT: $n${NC}"; idx=0; declare -a H; declare -a M
        while IFS="|" read h d m; do
            H[$idx]="$h"; M[$idx]="$m"; printf "[%d] %s %s\n" $((idx+1)) $h "${m:0:40}"; ((idx++))
        done < <(git -C "$tmp" log -n 15 --pretty="%h|%ad|%s")
        read -p "[N] Edit | [q] Quit: " op; [[ "$op" == "q" ]] && break
        [[ "$op" =~ ^[0-9]+$ ]] && editar "$tmp" "${H[$((op-1))]}" "${M[$((op-1))]}"
    done
    rm -rf "$tmp"
}

start() {
    clear; echo -e "${AZUL}GITHUB VERSE MANAGER${NC}"
    read -p "User (Enter=Self): " inp; TARGET=${inp:-$(gh api user -q .login)}
    raw=$(gh repo list $TARGET --limit 50 --json name,url --template '{{range .}}{{printf "%s|%s\n" .name .url}}{{end}}')
    P_N=(); P_U=(); c=0
    while IFS="|" read n u; do P_N[$c]=$n; P_U[$c]=$u; ((c++)); done <<< "$raw"
    
    while true; do
        clear; echo "REPOS: $TARGET"; for (( i=0; i<c; i++ )); do echo "[$((i+1))] ${P_N[$i]}"; done
        read -p "Op (u=user/q=exit): " op
        [[ "$op" == "u" ]] && return; [[ "$op" == "q" ]] && exit
        [[ "$op" =~ ^[0-9]+$ ]] && manager "${P_U[$((op-1))]}" "${P_N[$((op-1))]}"
    done
}

while true; do start; done
