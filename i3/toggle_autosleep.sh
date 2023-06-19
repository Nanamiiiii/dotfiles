#!/bin/bash

if xset q | grep "DPMS is Enabled" > /dev/null ; then
    xset s off -dpms
    notify-send "Display Power Setting" "Autosleep is disabled" -u normal
else
    xset s on +dpms
    notify-send "Display Power Setting" "Autosleep is enabled" -u normal
fi

