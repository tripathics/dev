#!/usr/bin/env bash

PID_FILE="/tmp/hyprsunset.pid"
ENABLED_ICON=󰖚
DISABLED_ICON=

set_hyprsunset() {
    if [[ "$1" == "ENABLE" ]]; then
        hyprsunset -t 5000 > /dev/null 2>&1 &
        echo $! > "$PID_FILE"
    elif [[ -f "$PID_FILE" ]]; then
        pkill -F "$PID_FILE"
        rm "$PID_FILE"
    fi
    # reload hyprsunset module in waybar
    pkill -SIGRTMIN+8 waybar
}

toggle_hyprsunset() {
    if [[ -f "$PID_FILE" ]]; then
        set_hyprsunset "DISABLE"
    else
        set_hyprsunset "ENABLE"
    fi
}

print_status() {
    if [[ -f "$PID_FILE" ]]; then 
        CLASS="enabled"
        TEXT="$ENABLED_ICON ON"
        TOOLTIP="hyprsunset on"
    else
        CLASS="disabled"
        TEXT="$DISABLED_ICON OF"
        TOOLTIP="hyprsunset off"
    fi
    printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' "$TEXT" "$CLASS" "$TOOLTIP"
}

# Auto toggle based on time
automatic_toggle() {
    CURRENT_HOUR=$(date +%H)
    if [ "$CURRENT_HOUR" -ge 18 ] || [ "$CURRENT_HOUR" -lt 6 ]; then
        set_hyprsunset "ENABLE"
    else
        set_hyprsunset "DISABLE"
    fi
    print_status
}

NO_ARGS=0
E_OPTERROR=85

if [ $# -eq $NO_ARGS ]
then
    toggle_hyprsunset
    exit 0
fi

if [ $# -gt 1 ]
then
    echo "Usage: `basename $0` -[g|s|u|a]"
    echo "  -g  Get status"
    echo "  -a  Auto toggle based on time and get status"
    echo "  -s  Set (enable) hyprsunset"
    echo "  -u  Unset (disable) hyprsunset"
    echo "  Toggle hyprsunset if no arguments are provided"
    exit $E_OPTERROR
fi

while getopts ":agsu" Option
do
    case $Option in
        s ) set_hyprsunset "ENABLE" ;;
        u ) set_hyprsunset "DISABLE" ;;
        g ) print_status ;;
        a ) automatic_toggle ;;
        * ) echo "Invalid option"; exit $E_OPTERROR ;;
    esac
done

shift $(($OPTIND - 1))

