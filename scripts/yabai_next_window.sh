#!/bin/bash

FOCUSED=$(yabai -m query --windows --window 2> /dev/null)
FOCUSED_ID=$(echo "$FOCUSED" | jq ".id")

if [ -n "$FOCUSED_ID" ]; then
    UNFOCUSED=$(yabai -m query --windows --space | jq "[ .[] | if .id != $FOCUSED_ID then . else empty end]")
    UPPER_ID=$(echo "$UNFOCUSED" | jq "[ .[] | if .id > $FOCUSED_ID then . else empty end]")
    if [ "$(echo "$UPPER_ID" | jq ". | length")" -gt 0 ]; then
        NEXT=$(echo "$UPPER_ID" | jq "[ .[].id ] | min")
        yabai -m window --focus "$NEXT"
    else
        NEXT=$(echo "$UNFOCUSED" | jq "[ .[].id ] | min")
        yabai -m window --focus "$NEXT"
    fi
else
    UNFOCUSED=$(yabai -m query --windows --space)
    NEXT=$(echo "$UNFOCUSED" | jq "[ .[].id ] | min")
    yabai -m window --focus "$NEXT"
fi

