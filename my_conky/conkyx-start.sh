#!/bin/sh
sleep 5

if ! pgrep -a "^conky$" ; then
    echo "launching conky..."
    conky -c ~/.config/conky/my_conky/conkyminimal.conf
fi
