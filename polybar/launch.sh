#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Enumerate Monitors
PRIMARY=$(polybar -m | grep "primary" | sed -e 's/:.*$//g')
SECONDARIES=(`polybar -m | grep -v "primary" | sed -e 's/:.*$//g' | sort`)
export POLY_MONITOR_0="$PRIMARY"
export POLY_MONITOR_1=${SECONDARIES[0]} 
export POLY_MONITOR_2=${SECONDARIES[1]} 

# Launch the bar
polybar -q main -c "$DIR"/config.ini &
polybar -q sub -c "$DIR"/config.ini &
polybar -q sub2 -c "$DIR"/config.ini &
