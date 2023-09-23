#!/bin/bash

FRONT_APP_SCRIPT='[ "$SENDER" = "front_app_switched" ] && sketchybar --set $NAME label="$INFO" icon=$($CONFIG_DIR/plugins/icon_map.sh "$INFO")'

front_app=(
  icon.drawing=on
  label.font="$FONT:Black:12.0"
  icon.font="sketchybar-app-font:Regular:12.0"
  associated_display=active
  script="$FRONT_APP_SCRIPT"
)

sketchybar --add item front_app left         \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched
