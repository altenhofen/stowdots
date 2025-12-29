#!/usr/bin/env bash

BASE="$HOME/pillow"
TERMINAL=gnome-terminal

cd "$BASE" || exit

sel=$(rg --files \
        -g '!*.flac' \
        -g '!*.mp3' \
        -g '!*.m4a' \
        | rofi -dmenu -i -p "Files") || exit

mime=$(file --mime-type -b "$sel")

if [[ "$mime" == text/* ]]; then
    exec $TERMINAL -- nvim "$sel"
else
    exec xdg-open "$sel"
fi

