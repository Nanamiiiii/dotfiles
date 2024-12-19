# Key bindings
bindkey "\e[3~" delete-char

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
    "${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin"(N-/)
    "$path[@]"
)
fpath=(
    "${ZDOTDIR:-~}/.zsh_functions"
    "$fpath[@]"
)

# Title
autoload -Uz add-zsh-hook
function _set_title() {
    echo -ne "\033]0;${USER}@${HOST}\007"
}
function _set_cmd_title() {
    cmd=$(echo ${2} | awk '{print $1}')
    echo -ne "\033]0;${cmd}\007"
}
add-zsh-hook precmd _set_title
add-zsh-hook preexec _set_cmd_title

# Check required app
## rbenv
if ( $(command -v rbenv > /dev/null) )
then
    eval "$(rbenv init - zsh)"
fi

## rubygems
if ( $(command -v gem > /dev/null) )
then
    path+=$(gem environment | grep "EXECUTABLE DIRECTORY" | awk '{print $4}')
fi 

## ghcup
if [[ -f "${HOME}/.ghcup/env" ]]; then
    . "${HOME}/.ghcup/env" # ghcup-env
fi

# History
export HISTFILE="${ZDOTDIR}/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY

# Sheldon
eval "$(sheldon source)"

# Completions
on_demand_completion 'aqua'
on_demand_completion 'bat' '/bin/cat $(dirname $(aqua which bat))/autocomplete/bat.zsh' 
on_demand_completion 'fzf' 'fzf --zsh'
on_demand_completion 'procs' 'procs --gen-completion-out zsh'
on_demand_completion 'ghq' '/bin/cat $(dirname $(aqua which ghq))/misc/zsh/_ghq' 
on_demand_completion 'fd' '/bin/cat $(dirname $(aqua which fd))/autocomplete/_fd' 
on_demand_completion 'rg' 'rg --generate complete-zsh'
on_demand_completion 'zoxide' '/bin/cat $(dirname $(aqua which zoxide))/completions/_zoxide'
on_demand_completion 'gh' 'gh completion -s zsh'

[[ ! -f "${ZDOTDIR}/.zsh_functions/_eza" ]] && curl "https://raw.githubusercontent.com/eza-community/eza/refs/heads/main/completions/zsh/_eza" > "${ZDOTDIR}/.zsh_functions/_eza"
[[ ! -f "${ZDOTDIR}/.zsh_functions/_dust" ]] && curl "https://raw.githubusercontent.com/bootandy/dust/refs/heads/master/completions/_dust" > "${ZDOTDIR}/.zsh_functions/_dust"
[[ ! -f "${ZDOTDIR}/.zsh_functions/_fastfetch" ]] && curl "https://raw.githubusercontent.com/fastfetch-cli/fastfetch/refs/heads/dev/completions/fastfetch.zsh" > "${ZDOTDIR}/.zsh_functions/_fastfetch"


# Starship
if ( $(command -v starship > /dev/null) )
then
    eval "$(starship init zsh)"
fi

# Keymap & functions
## ghq & fzf
## refs: https://gist.github.com/sheepla/d680f1480d8c36c4290d6aabebf1abc6
function _fzf_cd_ghq() {
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --reverse --height=50%"
    local root="$(ghq root)"
    local repo="$(ghq list | fzf --preview="ls -AF --color=always ${root}/{1}")"
    local dir="${root}/${repo}"
    [ -n "${dir}" ] && __zoxide_z "${dir}" # Use zoxide instead of cd
    zle accept-line
    zle reset-prompt
}

zle -N _fzf_cd_ghq
bindkey -M viins "^g" _fzf_cd_ghq

## Fuzzy find history
function _fzf_select_history(){
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N _fzf_select_history

function zvm_after_init() {
    bindkey -M viins "^R" _fzf_select_history
}

## Random Generator
function rand_str() {
    if [ $# -eq 0 ]; then
        RAND_LEN=16
    else
        RAND_LEN=$1
    fi
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$RAND_LEN"; echo
}

function rand_sym() {
    if [ $# -eq 0 ]; then
        RAND_LEN=16
    else
        RAND_LEN=$1
    fi
    LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' < /dev/urandom | head -c "$RAND_LEN"; echo
}

function rand_hex() {
    if [ $# -eq 0 ]; then
        RAND_LEN=16
    else
        RAND_LEN=$1
    fi
    LC_ALL=C tr -dc 'a-f0-9' < /dev/urandom | head -c "$RAND_LEN"; echo
}

# Aliases
alias -- cat='bat --style=plain --paging=never'
alias -- cp='cp -i'
alias -- df=duf
alias -- du=dust
alias -- dus='dust --depth=1'
alias -- find=fd
alias -- la='eza --icons --group-directories-first -a'
alias -- less='bat --style=plain'
alias -- lg=lazygit
alias -- ll='eza --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
alias -- ls='eza --icons --group-directories-first'
alias -- ps=procs
alias -- ptree='procs --tree'
alias -- rm='rm -i'
alias -- tree='eza --group-directories-first -T --icons'
alias -- vi=nvim
alias -- vim=nvim

# local rc
[[ -f "${ZDOTDIR}/.zshrc.local" ]] && source "${ZDOTDIR}/.zshrc.local"

