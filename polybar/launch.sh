#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Enumerate Monitors
DISPLAYS=(`polybar -m | grep -v "primary" | sed -e 's/:.*$//g' | sort`)
export POLY_MONITOR_0=$(polybar -m | grep "primary" | sed -e 's/:.*$//g')
#export POLY_MONITOR_1=${DISPLAYS[1]} 
#export POLY_MONITOR_2=${DISPLAYS[2]} 

# Launch the bar
polybar -q main-left -c "$DIR"/config.ini &
polybar -q main-ws -c "$DIR"/config.ini &
polybar -q main-right -c "$DIR"/config.ini &
polybar -q main-center -c "$DIR"/config.ini &
polybar -q main-media -c "$DIR"/config.ini &
polybar -q main-tray -c "$DIR"/config.ini &
POLY_MONITOR_1=${DISPLAYS[0]} polybar -q sub-ws -c "$DIR"/config.ini &
POLY_MONITOR_1=${DISPLAYS[1]} polybar -q sub-ws-wqhd -c "$DIR"/config.ini &
#polybar -q sub -c "$DIR"/config.ini &
#polybar -q sub2 -c "$DIR"/config.ini &
