#!/bin/bash

CURRENT=$(yabai -m query --spaces --space)
CURRENT_ID=$(echo "$CURRENT" | jq -r ".index")
CURRENT_TYPE=$(echo "$CURRENT" | jq -r ".type")

if [ "$CURRENT_TYPE" = "bsp" ]; then
    yabai -m space "$CURRENT_ID" --layout float
elif [ "$CURRENT_TYPE" = "float" ]; then
    yabai -m space "$CURRENT_ID" --layout bsp
else
    echo "Unknown type: ${CURRENT_TYPE}"
fi

