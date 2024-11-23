#!/usr/bin/env bash

case ${1} in
    "nvim")
        echo -n " "
        ;;
    "vim")
        echo -n " "
        ;;
    "tmux")
        echo -n " "
        ;;
    "git")
        echo -n " "
        ;;
    "ssh")
        echo -n "󰍺  "
        ;;
    "brew")
        echo -n -e "\xF0\x9f\x8d\xba"
        ;;
    "paru" | "yay" | "pacman")
        echo -n "󰏖 "
        ;;
    "cmake" | "make" | "cargo" | "gcc" | "clang")
        echo -n "󱌢 "
        ;;
    "less" | "bat")
        echo -n "󱔗 "
        ;;
    *)
        echo -n " "
        ;;
esac
