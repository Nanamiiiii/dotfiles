#!/bin/bash

TARGET_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[].name' | wofi --dmenu -p "Move to ..." -H "300")
swaymsg -t move workspace to ${TARGET_OUTPUT}

