#
# Nix Shell
#
# Nix can be used to provide some kind of virtual environment through the nix-shell command.
# Link: https://nixos.org/manual/nix/stable/command-ref/nix-shell.html

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_NIX_SHELL_SHOW="${SPACESHIP_NIX_SHELL_SHOW=true}"
SPACESHIP_NIX_SHELL_ASYNC="${SPACESHIP_NIX_SHELL_ASYNC=false}"
SPACESHIP_NIX_SHELL_PREFIX="${SPACESHIP_NIX_SHELL_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_NIX_SHELL_SUFFIX="${SPACESHIP_NIX_SHELL_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_NIX_SHELL_SYMBOL="${SPACESHIP_NIX_SHELL_SYMBOL="❄ "}"
SPACESHIP_NIX_SHELL_COLOR="${SPACESHIP_NIX_SHELL_COLOR="yellow"}"
SPACESHIP_NIX_SHELL_IMPURE="${SPACESHIP_NIX_SHELL_IMPURE="󰼩 "}"
SPACESHIP_NIX_SHELL_PURE="${SPACESHIP_NIX_SHELL_PURE="󱩰 "}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Shows whether nix-shell environment is active
spaceship_nix_shell() {
  [[ $SPACESHIP_NIX_SHELL_SHOW == false ]] && return

  [[ -z "$IN_NIX_SHELL" ]] && return

  shell_symbol=""
  if [[ "$IN_NIX_SHELL" == "pure" ]]; then
    shell_symbol="$SPACESHIP_NIX_SHELL_PURE"
  elif [[ "$IN_NIX_SHELL" == "impure" ]]; then
    shell_symbol="$SPACESHIP_NIX_SHELL_IMPURE"
  fi

  if [[ -z "$name" || "$name" == "" ]]; then
    display_text=""
  else
    display_text="$name"
  fi

  # Show prompt section
  spaceship::section \
    --color "$SPACESHIP_NIX_SHELL_COLOR" \
    --prefix "$SPACESHIP_NIX_SHELL_PREFIX" \
    --suffix "$SPACESHIP_NIX_SHELL_SUFFIX" \
    --symbol "$shell_symbol" \
    "$display_text"
}
