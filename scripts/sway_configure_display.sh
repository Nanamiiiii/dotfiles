#!/bin/bash

TARGET_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[].name' | wofi --dmenu -p "Target display ..." -H "300")

case $((echo 'Mode'; echo 'Power'; echo 'Cancel') | wofi --dmenu -p "Command" -H "300") in
    "Mode")
        echo "Currently not supported."
        ;;
    "Power")
        case $((echo 'On'; echo 'Off') | wofi --dmenu -p "Display Power" -H "300") in
            "On")
                swaymsg -- output ${TARGET_OUTPUT} enable
                ;;
            "Off")
                swaymsg -- output ${TARGET_OUTPUT} disable
                ;;
            *)
                echo "Error: invalid command"
                ;;
        esac
        ;;
    "Cancel")
        ;;
    *)
        echo "Error: invalid command"
        ;;
esac

