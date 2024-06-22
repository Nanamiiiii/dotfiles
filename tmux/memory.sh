#!/usr/bin/env bash

ratio=""
if [[ $(uname) == 'Darwin' ]]; then
    ratio=$(memory_pressure -Q | awk '/^System-wide/{print $5}')
elif [[ $(uname) == 'Linux' ]]; then
    raw=$(free | grep "Mem:")
    total=$(echo ${raw} | awk '{print $2}')
    free=$(echo ${raw} | awk '{print $3}')
    ratio=$(printf "%.2f%%" $((${free}./${total}*100)))
fi

echo "${RESET}#[fg=${bblue}]  #[fg=${foreground}]${ratio}"

