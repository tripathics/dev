#!/usr/bin/env bash

STATE="$XDG_RUNTIME_DIR/hyprsunset-mode"
AUTO_ICON=󰃡
ENABLED_ICON=󰖚
DISABLED_ICON=

MANUAL_TEMP=3000

mode() {
    [[ -f "$STATE" ]] && cat "$STATE" || echo auto
}

set_hyprsunset() {
    case "$1" in
        auto)
            hyprctl hyprsunset reset
            ;;
        on)
            hyprctl hyprsunset temperature $MANUAL_TEMP
            ;;
        off)
            hyprctl hyprsunset identity
            ;;
    esac
    echo "$1" > "$STATE"

    # reload hyprsunset module in waybar
    pkill -SIGRTMIN+8 waybar
}

print_status() {
    case $(mode) in
        auto)
            CLASS="auto"
            TEXT="$AUTO_ICON"
            TOOLTIP="Auto"
            ;;
        on)
            CLASS="enabled"
            TEXT="$ENABLED_ICON"
            TOOLTIP="On: ${MANUAL_TEMP}K"
            ;;
        off)
            CLASS="disabled"
            TEXT="$DISABLED_ICON"
            TOOLTIP="Off: 6000K"
            ;;
    esac

    TOOLTIP="Hyprsunset $TOOLTIP"
    printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' "$TEXT" "$CLASS" "$TOOLTIP"
}

NO_ARGS=0
E_OPTERROR=85

cycle_hyprsunset() {
    case "$1" in
        on|off|auto)
            set_hyprsunset "$1"
            ;;
        *)
            case "$(mode)" in
                on)
                    set_hyprsunset off
                    ;;
                off)
                    set_hyprsunset auto
                    ;;
                auto)
                    set_hyprsunset on
                    ;;
            esac
    esac
}

if [ $# -eq $NO_ARGS ]
then
    cycle_hyprsunset
    exit 0
fi

if [ $# -gt 1 ]
then
    echo "Usage: `basename $0` -[g|s|u]"
    echo "  -g  Get status"
    echo "  -s  Set (enable) hyprsunset"
    echo "  -u  Unset (disable) hyprsunset"
    echo "  Cycle hyprsunset between on|off|auto with no args"
    exit $E_OPTERROR
fi

while getopts ":agsu" Option
do
    case $Option in
        s ) set_hyprsunset on ;;
        u ) set_hyprsunset off ;;
        g ) print_status ;;
        * ) echo "Invalid option"; exit $E_OPTERROR ;;
    esac
done

shift $(($OPTIND - 1))

