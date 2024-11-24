#!/usr/bin/env bash

format_none="0123456789"
format_digital="🯰🯱🯲🯳🯴🯵🯶🯷🯸🯹"
format_fsquare="󰎡󰎤󰎧󰎪󰎭󰎱󰎳󰎶󰎹󰎼"
format_hsquare="󰎣󰎦󰎩󰎬󰎮󰎰󰎵󰎸󰎻󰎾"
format_dsquare="󰎢󰎥󰎨󰎫󰎲󰎯󰎴󰎷󰎺󰎽"
format_roman=" 󱂈󱂉󱂊󱂋󱂌󱂍󱂎󱂏󱂐"
format_super="⁰¹²³⁴⁵⁶⁷⁸⁹"
format_sub="₀₁₂₃₄₅₆₇₈₉"
format_hexa="󰋙󰫃󰫄󰫅󰫆󰫇󰫈"

ID=$1
FORMAT=${2:-none}

# Preserve leading whitespace for bash
format="$(eval echo \"\$format_${FORMAT}\")"
if [ -z "$format" ]; then
    echo "Invalid format: $FORMAT"
    exit 1
fi

# If format is roman numerals (-r), only handle IDs of 1 digit
if [ "$FORMAT" = "roman" ] && [ ${#ID} -gt 1 ]; then
    echo -n $ID
    continue
elif [ "$FORMAT" = "hexa" ]; then
    out=""
    filled=$((${ID}/6)) 
    mod=$((${ID}%6))
    for ((i = 0; i < ${filled}; i++)); do
        out=${out}${format:6:1}
    done
    if [ "$mod" -ne 0 ] || [ "$filled" -eq 0 ]; then
        out=${out}${format:mod:1}
    fi
    echo -n "$out"
else
    for ((i = 0; i < ${#ID}; i++)); do
        DIGIT=${ID:i:1}
        echo -n "${format:DIGIT:1}"
    done
fi
