# Path
typeset -U path
typeset -U fpath
path=(
    "$HOME/.local/bin"(N-/)
    "$HOME/.scripts"(N-/)
    "$CARGO_HOME/bin"(N-/)
    "$DENO_INSTALL/bin"(N-/)
    "$GOPATH/bin"(N-/)
    "$HOME/.local/go/bin"(N-/)
    "${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin/aqua"(N-/)
    "$path[@]"
)
fpath=(
    "${ZDOTDIR:-~}/.zsh_functions"
    "$fpath[@]"
)

export EDITOR="nvim"

[[ -f "${ZDOTDIR}/.zprofile.local" ]] && source "${ZDOTDIR}/.zprofile.local"

