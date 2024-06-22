#!/usr/bin/env bash
#<------------------------------Netspeed widget for TMUX------------------------------------>
# author : @tribhuwan-kumar
# email : freakybytes@duck.com
#<------------------------------------------------------------------------------------------>

# Get network transmit data
function get_bytes() {
  local interface="$1"
  if [[ "$(uname)" == "Linux" ]]; then
    awk -v interface="$interface" '$1 == interface ":" {print $2, $10}' /proc/net/dev
  elif [[ "$(uname)" == "Darwin" ]]; then
    netstat -ib | awk -v interface="$interface" '/^'"${interface}"'/ {print $7, $10}' | head -n1
  else
    # Unsupported operating system
    exit 1
  fi
}

# Convert into readable format
function readable_format() {
  local bytes=$1
  local secs=${2:-1}

  if [[ $bytes -lt 1048576 ]]; then
    echo "$(bc -l <<<"scale=1; $bytes / 1024 / $secs")KB/s"
  else
    echo "$(bc -l <<<"scale=1; $bytes / 1048576 / $secs")MB/s"
  fi
}

# Auto-determine interface
function find_interface() {
  local interface
  if [[ $(uname) == "Linux" ]]; then
    interface=$(awk '$2 == 00000000 {print $1}' /proc/net/route)
  elif [[ $(uname) == "Darwin" ]]; then
    interface=$(route get default 2>/dev/null | grep interface | awk '{print $2}')
    # If VPN, fallback to en0
    [[ ${interface:0:4} == "utun" ]] && interface="en0"
  fi
  echo "$interface"
}

# Detect interface IPv4 and status
function interface_ipv4() {
  local interface="$1"
  local ipv4_addr
  local status="up" # Default assumption
  if [[ $(uname) == "Darwin" ]]; then
    # Check for an IPv4 on macOS
    ipv4_addr=$(ipconfig getifaddr "$interface")
    [[ -z $ipv4_addr ]] && status="down"
  elif [[ $(uname) == "Linux" ]]; then
    # Use 'ip' command to check for IPv4 address
    if command -v ip >/dev/null 2>&1; then
      ipv4_addr=$(ip addr show dev "$interface" 2>/dev/null | grep "inet\b" | awk '{sub("/.*", "", $2); print $2}')
      [[ -z $ipv4_addr ]] && status="down"
    # Use 'ifconfig' command to check for IPv4 address
    elif command -v ifconfig >/dev/null 2>&1; then
      ipv4_addr=$(ifconfig "$interface" 2>/dev/null | grep "inet\b" | awk '{print $2}')
      [[ -z $ipv4_addr ]] && status="down"
    # Fallback to operstate on Linux
    elif [[ $(cat "/sys/class/net/$interface/operstate" 2>/dev/null) != "up" ]]; then
      status="down"
    fi
  fi
  echo "$ipv4_addr"
  [[ $status == "up" ]] && return 0 || return 1
}

# Check if enabled
ENABLED=$(tmux show-option -gv @show_netspeed 2>/dev/null)
[[ ${ENABLED} -ne 1 ]] && exit 0

# Get network interface
INTERFACE=$(tmux show-option -gv @netspeed_iface 2>/dev/null)
# Show IP address
SHOW_IP=$(tmux show-option -gv @netspeed_showip 2>/dev/null)
# Time between refresh
TIME_DIFF=$(tmux show-option -gv @netspeed_refresh 2>/dev/null)
TIME_DIFF=${TIME_DIFF:-1}

# Icons
declare -A NET_ICONS
NET_ICONS[wifi_up]="#[fg=#a9b1d6]\U000f0928"  # nf-md-wifi
NET_ICONS[wifi_down]="#[fg=#f7768e]\U000f092d"       # nf-md-wifi_off
NET_ICONS[wired_up]="#[fg=#a9b1d6]\U000f0318" # nf-md-lan_connect
NET_ICONS[wired_down]="#[fg=#f7768e]\U000f0319"      # nf-md-lan_disconnect
NET_ICONS[traffic_tx]="#[fg=#7aa2f7]\U000f40a"    # nf-md-upload_network
NET_ICONS[traffic_rx]="#[fg=#41a6b5]\U000f409"   # nf-md-download_network
NET_ICONS[ip]="#[fg=#a9b1d6]\U000f0a5f"       # nf-md-ip

# Determine interface if not set
if [[ -z $INTERFACE ]]; then
  INTERFACE=$(find_interface)
  [[ -z $INTERFACE ]] && exit 1
  # Update tmux option for this session
  tmux set-option -g @netspeed_iface "$INTERFACE"
fi

# Echo network speed
read -r RX1 TX1 < <(get_bytes "$INTERFACE")
sleep "$TIME_DIFF"
read -r RX2 TX2 < <(get_bytes "$INTERFACE")

RX_DIFF=$((RX2 - RX1))
TX_DIFF=$((TX2 - TX1))

RX_SPEED="#[fg=#a9b1d6]$(readable_format "$RX_DIFF" "$TIME_DIFF")"
TX_SPEED="#[fg=#a9b1d6]$(readable_format "$TX_DIFF" "$TIME_DIFF")"

# Interface icon
if [[ ${INTERFACE} == "en0" ]] || [[ -d /sys/class/net/${INTERFACE}/wireless ]]; then
  IFACE_TYPE="wifi"
else
  IFACE_TYPE="wired"
fi

# Detect interface IPv4 and state
if IPV4_ADDR=$(interface_ipv4 "$INTERFACE"); then
  IFACE_STATUS="up"
else
  IFACE_STATUS="down"
fi

NETWORK_ICON=${NET_ICONS[${IFACE_TYPE}_${IFACE_STATUS}]}

OUTPUT="${RESET}░ ${NET_ICONS[traffic_rx]} $RX_SPEED ${NET_ICONS[traffic_tx]} $TX_SPEED $NETWORK_ICON #[dim]$INTERFACE "
if [[ ${SHOW_IP} -ne 0 ]] && [[ -n $IPV4_ADDR ]]; then
  OUTPUT+="${NET_ICONS[ip]} #[dim]$IPV4_ADDR "
fi

echo -e "$OUTPUT"
