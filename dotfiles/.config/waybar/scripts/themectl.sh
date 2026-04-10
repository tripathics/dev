#!/usr/bin/env bash

MOON=" 󱨥"
MOON_OFF=" 󱨦"
SUN=󰽤

CURR_THEME="$(gsettings get org.gnome.desktop.interface color-scheme)"
CURR_THEME=${CURR_THEME//\'/}

set_theme() {
  if [[ "$1" == "LIGHT" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  fi
  # reload waybar
  pkill -SIGRTMIN+7 waybar
}

get_theme() {
  if [[ "$CURR_THEME" == "prefer-light" || "$CURR_THEME" == "default" ]]; then
    CLASS="light"
    TEXT="$MOON_OFF"
    TOOLTIP="Light"
  else
    CLASS="dark"
    TEXT="$MOON"
    TOOLTIP="Dark"
  fi
  printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' "$TEXT" "$CLASS" "$TOOLTIP"
}

toggle_theme() {
  if [[ "$CURR_THEME" == "prefer-light" || "$CURR_THEME" == "default" ]]; then
    set_theme "DARK"
  else
    set_theme "LIGHT"
  fi
}

NO_ARGS=0
E_OPTERROR=85

if [ $# -eq $NO_ARGS ]; then
  toggle_theme
  exit 0
fi

while getopts ":gld" Option
do
  case $Option in
    l ) set_theme "LIGHT" ;;
    d ) set_theme "DARK" ;;
    g ) get_theme ;;
    * ) echo "Invalid option"; exit $E_OPTERROR ;;
  esac
done

shift $(($OPTIND - 1))
