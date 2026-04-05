#!/usr/bin/env bash

[[ -z $WALLPAPER_DIR ]] && WALLPAPER_DIR="$HOME/wp"

WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

hyprctl hyprpaper wallpaper ",${WALLPAPER},cover"

