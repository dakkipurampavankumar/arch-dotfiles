#!/bin/bash

# Target temperature in Kelvin
TEMP=5000

case $1 in
    toggle)
        if pgrep -x "wlsunset" > /dev/null; then
            pkill wlsunset
        else
            wlsunset -t $TEMP -T $((TEMP + 1)) &
        fi
        pkill -RTMIN+12 waybar
        ;;
    on)
        # Only start it if it is not already running
        if ! pgrep -x "wlsunset" > /dev/null; then
            wlsunset -t $TEMP -T $((TEMP + 1)) &
        fi
        pkill -RTMIN+12 waybar
        ;;
    status)
        if pgrep -x "wlsunset" > /dev/null; then
            echo '{"text": "", "alt": "on", "tooltip": "Night Light: ON", "class": "on"}'
        else
            echo '{"text": "", "alt": "off", "tooltip": "Night Light: OFF", "class": "off"}'
        fi
        ;;
esac
