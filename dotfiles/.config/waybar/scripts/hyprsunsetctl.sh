#!/usr/bin/env bash
STATE="$XDG_RUNTIME_DIR/hyprsunset-mode"
PEEK="$XDG_RUNTIME_DIR/hyprsunset-peek"

AUTO_ICON=󰃡
ENABLED_ICON=󰖚
DISABLED_ICON=

MANUAL_TEMP=3000
NO_ARGS=0
E_OPTERROR=85

mode() {
    [[ -f "$STATE" ]] && cat "$STATE" || echo auto
}

refresh_waybar() {
    pkill -SIGRTMIN+8 waybar
}

set_hyprsunset() {
    case "$1" in
        auto) hyprctl hyprsunset reset >/dev/null 2>&1 ;;
        on)   hyprctl hyprsunset temperature "$MANUAL_TEMP" >/dev/null 2>&1 ;;
        off)  hyprctl hyprsunset identity >/dev/null 2>&1 ;;
    esac
    echo "$1" > "$STATE"
    refresh_waybar
}

cycle_hyprsunset() {
    case "$1" in
        on|off|auto) set_hyprsunset "$1" ;;
        *)
            case "$(mode)" in
                on)   set_hyprsunset off ;;
                off)  set_hyprsunset auto ;;
                auto) set_hyprsunset on ;;
            esac
            ;;
    esac
}

print_status() {
    case "$(mode)" in
        auto) CLASS="auto";     TEXT="$AUTO_ICON" ;;
        on)   CLASS="enabled";  TEXT="$ENABLED_ICON" ;;
        off)  CLASS="disabled"; TEXT="$DISABLED_ICON" ;;
    esac
    TOOLTIP="Hyprsunset $(mode)"
    if [[ -f "$PEEK" ]]; then
        TEXT="$TEXT $(cat "$PEEK")K"
    fi
    jq -cn \
        --arg text "$TEXT" \
        --arg class "$CLASS" \
        --arg tooltip "$TOOLTIP" \
        '{text: $text, class: $class, tooltip: $tooltip}'
}

peek_temperature() {
    if [[ -f "$PEEK" ]]; then
        rm -f "$PEEK" "$PEEK.lock"
        refresh_waybar
        return
    fi

    case "$(mode)" in
        on)   TEMP="$MANUAL_TEMP" ;;
        off)  TEMP="6000" ;;
        auto) TEMP="$(hyprctl hyprsunset profile | awk '/Temp/{print $2}')" ;;
    esac

    local token="${$}_$(date +%s%N)"
    echo "$token" > "$PEEK.lock"
    echo "$TEMP" > "$PEEK"
    refresh_waybar

    {
        sleep 5
        if [[ "$(cat "$PEEK.lock" 2>/dev/null)" == "$token" ]]; then
            rm -f "$PEEK" "$PEEK.lock"
            refresh_waybar
        fi
    } & disown
}

if [ $# -eq $NO_ARGS ]; then
    cycle_hyprsunset
    exit 0
fi

if [ $# -gt 1 ]; then
    echo "Usage: $(basename "$0") -[g|s|u|t]"
    echo "  -g  Get status"
    echo "  -t  Get temperature"
    echo "  -s  Set (enable) hyprsunset"
    echo "  -u  Unset (disable) hyprsunset"
    echo "  Cycle hyprsunset between on|off|auto with no args"
    exit $E_OPTERROR
fi

while getopts ":sugt" Option; do
    case $Option in
        s) set_hyprsunset on ;;
        u) set_hyprsunset off ;;
        g) print_status ;;
        t) peek_temperature ;;
        *) echo "Invalid option"; exit $E_OPTERROR ;;
    esac
done
shift $((OPTIND - 1))
