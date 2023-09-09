#!/bin/bash

FOCUSED=$(yabai -m query --windows --window)
FOCUSED_ID=$(echo "$FOCUSED" | jq ".id")
UNFOCUSED=$(yabai -m query --windows --space | jq "[ .[] | if .id != $FOCUSED_ID then . else empty end]")
UPPER_ID=$(echo "$UNFOCUSED" | jq "[ .[] | if .id > $FOCUSED_ID then . else empty end]")


if [ "$(echo "$UPPER_ID" | jq ". | length")" -gt 0 ]; then
    NEXT=$(echo "$UPPER_ID" | jq "[ .[].id ] | min")
    yabai -m window --focus "$NEXT"
else
    NEXT=$(echo "$UNFOCUSED" | jq "[ .[].id ] | min")
    yabai -m window --focus "$NEXT"
fi

