#!/bin/sh

function lab_desk () {
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output eDP-1-1 --off
    i3-msg restart
}

function builtin () {
    xrandr --output HDMI-0 --off --output DP-0 --off --output DP-1 --off --output eDP-1-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
    i3-msg restart
}

function clone_hdmi() {

    i3-msg restart
}

function clone_dp () {

    i3-msg restart
}

LIST=("Laboratory Desk" "Built-in Display" "Clone to HDMI" "Clone to DP" "Launch ARandR" )
CMD_LIST=(
    "lab_desk"
    "builtin"
    ""
    ""
    "arandr"
)

DEFAULT_IFS="$IFS"
IFS=$'\n'

SELECT=$(echo -e "${LIST[*]}" | rofi -dmenu -p "Display Configuration" -a 0 -format i)

$(${CMD_LIST[$SELECT]})

