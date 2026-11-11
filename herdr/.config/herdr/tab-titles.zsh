# The Herdr numbering plugin adds the workspace-local "1. " prefix.
_inferno_herdr_tab_title() {
    [[ ${HERDR_ENV:-} == 1 && -n ${HERDR_TAB_ID:-} ]] || return 0
    command herdr tab rename "$HERDR_TAB_ID" "$1" >/dev/null 2>&1
    return 0
}

_inferno_herdr_tab_prompt() {
    _inferno_herdr_tab_title "${PWD:t}"
}

_inferno_herdr_tab_command() {
    local -a words
    words=( ${(z)1} )
    local word
    for word in "${words[@]}"; do
        # Skip environment assignments and common command prefixes.
        [[ $word =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]] && continue
        case $word in
            command|exec|env|sudo|noglob|nocorrect) continue ;;
            -*) continue ;;
        esac
        word=${(Q)word}
        _inferno_herdr_tab_title "${word:t}"
        return 0
    done
}

if [[ ${HERDR_ENV:-} == 1 && -n ${HERDR_TAB_ID:-} ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _inferno_herdr_tab_prompt
    add-zsh-hook preexec _inferno_herdr_tab_command
fi
