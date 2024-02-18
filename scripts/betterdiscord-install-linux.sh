#!/bin/bash

wget https://github.com/BetterDiscord/Installer/releases/latest/download/BetterDiscord-Linux.AppImage -P /tmp
chmod +x /tmp/BetterDiscord-Linux.AppImage
exec /tmp/BetterDiscord-Linux.AppImage
rm -f /tmp/BetterDiscord-Linux.AppImage

