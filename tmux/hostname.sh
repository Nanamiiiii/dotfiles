#!/usr/bin/env bash

type=""
if [[ $(uname) == "Linux" ]]; then
    type=$(hostnamectl | grep "Chassis" | awk '{print $2}')
elif [[ $(uname) == "Darwin" ]]; then
    type="laptop"
else
    type="desktop"
fi

icon=""
case ${type} in
    "desktop")
        icon="󰍹 "
        ;;
    "laptop")
        icon="󰌢 "
        ;;
    "server")
        icon="󰒋 "
        ;;
    "vm")
        icon=" "
        ;;
    *)
        icon="󰍹 "
        ;;
esac

no_domain=$(hostname | awk '{split($1, name, "."); print name[1]}')
echo "${RESET}${icon} #[bold]${no_domain}"

