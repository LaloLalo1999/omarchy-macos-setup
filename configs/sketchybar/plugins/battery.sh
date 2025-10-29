#!/bin/bash

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -n "$CHARGING" ]; then
    ICON="󰂄"
    COLOR=0xffa6e3a1  # Green
elif [ $PERCENTAGE -gt 80 ]; then
    ICON="󰁹"
    COLOR=0xffa6e3a1  # Green
elif [ $PERCENTAGE -gt 60 ]; then
    ICON="󰂀"
    COLOR=0xff89b4fa  # Blue
elif [ $PERCENTAGE -gt 40 ]; then
    ICON="󰁾"
    COLOR=0xfff9e2af  # Yellow
elif [ $PERCENTAGE -gt 20 ]; then
    ICON="󰁼"
    COLOR=0xfffab387  # Orange
else
    ICON="󰁺"
    COLOR=0xfff38ba8  # Red
fi

sketchybar --set $NAME icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%"
