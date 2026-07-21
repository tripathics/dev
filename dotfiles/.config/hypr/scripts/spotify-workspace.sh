#!/bin/bash

WORKSPACE=10
CLASS="^spotify"

WINDOW="$( hyprctl clients -j | jq '.[] | select(.class=="Spotify")' )"

if [[ -z $WINDOW ]] then
  hyprctl dispatch 'hl.dsp.exec_cmd("spotify-launcher")'
  exit
fi

WORKSPACE="$( hyprctl clients -j | jq '.[] | select(.class=="Spotify").workspace.id' )"
hyprctl dispatch "hl.dsp.focus { workspace = $WORKSPACE }"
