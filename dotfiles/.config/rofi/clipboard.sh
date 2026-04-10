#!/usr/bin/env bash

cliphist list | rofi -dmenu -p " " | cliphist decode | wl-copy
