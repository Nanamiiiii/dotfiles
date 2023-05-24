#!/bin/sh

DEV_ID=$(xinput list | grep "AT Translated Set 2 keyboard" | awk 'match($0, /id=([0-9]+)/, a) { print a[1] }')
xinput disable "$DEV_ID"

