#!/bin/sh
if [ $$ != `pgrep -fo $0` ]; then
  echo "Already running!" >&2
  exit 1
fi

echo "Launching mediaplayer daemon" >&2
python3 ~/.config/waybar/scripts/mediaplayer.py

exit 0

