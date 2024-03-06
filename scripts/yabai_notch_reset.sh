#!/usr/bin/env sh

# in external display, top padding is different
# on M1 or later macbook, the notch space working as padding
DISPLAY_UUID=37D8832A-2D66-02CA-B9F7-8F30A301B230 # UUID of built-in display

BAR_PADDING=50
DEFAULT_PADDING=12

SPACES_ON_SUB=$(yabai -m query --displays | jq ".[] | select(.uuid != \"${DISPLAY_UUID}\") | .spaces[]")
SPACES_ON_BUILTIN=$(yabai -m query --displays | jq ".[] | select(.uuid == \"${DISPLAY_UUID}\") | .spaces[]")

for idx in ${SPACES_ON_SUB}
do
    yabai -m config --space "$idx" top_padding "$BAR_PADDING"
done

for idx in ${SPACES_ON_BUILTIN}
do
    yabai -m config --space "$idx" top_padding "$DEFAULT_PADDING"
done

