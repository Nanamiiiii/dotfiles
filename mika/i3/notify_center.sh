#!/bin/sh

pgrep deadd && killall deadd-notification-center
deadd-notification-center

