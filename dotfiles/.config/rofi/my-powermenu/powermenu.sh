#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Modified by: tripathics

# Import Current Theme
# source "$HOME"/.config/rofi/applets/shared/theme.bash

# type="$HOME/.config/rofi/applets/type-5"
# style='style-1.rasi'
theme="$HOME/.config/rofi/my-powermenu/theme.rasi"

# theme="./theme.rasi"

# Theme Elements
prompt="`uname -n`"
mesg="Uptime : `uptime -p | sed -e 's/up //g'`"
list_col='1'
list_row='6'

# Options
option_1=" Lock"
option_2=" Logout"
option_3=" Suspend"
option_4=" Hibernate"
option_5=" Reboot"
option_6=" Shutdown"
yes=' Yes'
no=' No'

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${theme}
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute
confirm_run () {	
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
	bash -c "$*"
    else
        exit
    fi	
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		hyprlock
	elif [[ "$1" == '--opt2' ]]; then
		confirm_run 'hyprctl dispatch exit'
	elif [[ "$1" == '--opt3' ]]; then
		confirm_run 'playerctl pause; hyprlock & sleep 1 && systemctl suspend'
	elif [[ "$1" == '--opt4' ]]; then
		confirm_run 'playerctl pause; hyprlock & sleep 1 && systemctl hibernate'
	elif [[ "$1" == '--opt5' ]]; then
		confirm_run 'systemctl reboot'
	elif [[ "$1" == '--opt6' ]]; then
		confirm_run 'systemctl poweroff'
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
esac

# vim: ts=4 sw=4 expandtab
