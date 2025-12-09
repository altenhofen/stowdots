#!/bin/bash

# 1. Define your wallpaper directory
WALLPAPER_DIR=~/Pictures/wallpapers 

WALLPAPER=$(find "$WALLPAPER_DIR" -type f -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "no wallpapers found in $WALLPAPER_DIR."
    exit 1
fi

hyprctl hyprpaper preload "$WALLPAPER"

hyprctl hyprpaper wallpaper ",$WALLPAPER"

# Unload unused wallpapers to free up memory
sleep 1
hyprctl hyprpaper unload unused
