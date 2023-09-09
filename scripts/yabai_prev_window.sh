#!/bin/bash

FOCUSED=$(yabai -m query --windows --window)
FOCUSED_ID=$(echo "$FOCUSED" | jq ".id")

if [ -n "$FOCUSED_ID" ]; then
    UNFOCUSED=$(yabai -m query --windows --space | jq "[ .[] | if .id != $FOCUSED_ID then . else empty end]")
    LOWER_ID=$(echo "$UNFOCUSED" | jq "[ .[] | if .id < $FOCUSED_ID then . else empty end]")
    if [ "$(echo "$LOWER_ID" | jq ". | length")" -gt 0 ]; then
        NEXT=$(echo "$LOWER_ID" | jq "[ .[].id ] | max")
        yabai -m window --focus "$NEXT"
    else
        NEXT=$(echo "$UNFOCUSED" | jq "[ .[].id ] | max")
        yabai -m window --focus "$NEXT"
    fi
else
    UNFOCUSED=$(yabai -m query --windows --space)
    NEXT=$(echo "$UNFOCUSED" | jq "[ .[].id ] | max")
    yabai -m window --focus "$NEXT"
fi

