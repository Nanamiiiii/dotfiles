SPACESHIP_OS_SHOW="${SPACESHIP_OS_SHOW=true}"
SPACESHIP_OS_PREFIX="${SPACESHIP_OS_PREFIX="%F{244}%bon %f"}"
SPACESHIP_OS_COLOR="${SPACESHIP_OS_COLOR="12"}"

spaceship_os() {
  [[ $SPACESHIP_OS_SHOW == false ]] && return

  local os_symbol=""

  if [[ "$(uname -s)" == "Darwin" ]]; then
    os_symbol="󰘳 "
  elif grep -qi "microsoft" /proc/version 2>/dev/null; then
    os_symbol=" "
  elif [[ -f /etc/os-release ]]; then
    local os_id=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    case "$os_id" in
      nixos)  os_symbol=" " ;;
      arch)   os_symbol="󰣇 " ;;
      ubuntu) os_symbol=" " ;;
      *)      os_symbol=" " ;;
    esac
  fi

  [[ -z "$os_symbol" ]] && return

  spaceship::section::v4 \
    --color "$SPACESHIP_OS_COLOR" \
    --prefix "$SPACESHIP_OS_PREFIX" \
    --symbol "$os_symbol " \
    ""
}

