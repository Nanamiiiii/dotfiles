#
# Working directory
#
# Current directory. Return only three last items of path

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_CDIR_SHOW="${SPACESHIP_CDIR_SHOW=true}"
SPACESHIP_CDIR_PREFIX="${SPACESHIP_CDIR_PREFIX="in "}"
SPACESHIP_CDIR_SUFFIX="${SPACESHIP_CDIR_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_CDIR_TRUNC="${SPACESHIP_CDIR_TRUNC=3}"
SPACESHIP_CDIR_TRUNC_PREFIX="${SPACESHIP_CDIR_TRUNC_PREFIX=}"
SPACESHIP_CDIR_TRUNC_REPO="${SPACESHIP_CDIR_TRUNC_REPO=true}"
SPACESHIP_CDIR_COLOR="${SPACESHIP_CDIR_COLOR="cyan"}"
SPACESHIP_CDIR_LOCK_SYMBOL="${SPACESHIP_CDIR_LOCK_SYMBOL=" "}"
SPACESHIP_CDIR_LOCK_COLOR="${SPACESHIP_CDIR_LOCK_COLOR="red"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_custom_dir() {
  [[ $SPACESHIP_DIR_SHOW == false ]] && return

  local dir trunc_prefix

  # Threat repo root as a top-level directory or not
  if [[ $SPACESHIP_CDIR_TRUNC_REPO == true ]] && spaceship::is_git; then
    local git_root=$(git rev-parse --show-toplevel)

    if (cygpath --version) >/dev/null 2>/dev/null; then
      git_root=$(cygpath -u $git_root)
    fi

    # Check if the parent of the $git_root is "/"
    if [[ $git_root:h == / ]]; then
      trunc_prefix=/
    else
      trunc_prefix=$SPACESHIP_CDIR_TRUNC_PREFIX
    fi

    # `${NAME#PATTERN}` removes a leading prefix PATTERN from NAME.
    # `$~~` avoids `GLOB_SUBST` so that `$git_root` won't actually be
    # considered a pattern and matched literally, even if someone turns that on.
    # `$git_root` has symlinks resolved, so we use `${PWD:A}` which resolves
    # symlinks in the working directory.
    # See "Parameter Expansion" under the Zsh manual.
    dir="$trunc_prefix$git_root:t${${PWD:A}#$~~git_root}"
  else
    if [[ SPACESHIP_CDIR_TRUNC -gt 0 ]]; then
      # `%(N~|TRUE-TEXT|FALSE-TEXT)` replaces `TRUE-TEXT` if the current path,
      # with prefix replacement, has at least N elements relative to the root
      # directory else `FALSE-TEXT`.
      # See "Prompt Expansion" under the Zsh manual.
      trunc_prefix="%($((SPACESHIP_CDIR_TRUNC + 1))~|$SPACESHIP_CDIR_TRUNC_PREFIX|)"
    fi

    dir="$trunc_prefix%${SPACESHIP_CDIR_TRUNC}~"
  fi

  local suffix="$SPACESHIP_CDIR_SUFFIX"

  if [[ ! -w . ]]; then
    suffix="%F{$SPACESHIP_CDIR_LOCK_COLOR}${SPACESHIP_CDIR_LOCK_SYMBOL}%f${SPACESHIP_CDIR_SUFFIX}"
  fi

  spaceship::section \
    --color "$SPACESHIP_CDIR_COLOR" \
    --prefix "$SPACESHIP_CDIR_PREFIX" \
    --suffix "$suffix" \
    "%b%{\e[3m%}${dir}%{\e[23m%}"
}
