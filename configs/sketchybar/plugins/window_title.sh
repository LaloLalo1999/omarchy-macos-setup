#!/bin/bash

WINDOW_TITLE=$(yabai -m query --windows --window | jq -r '.title // empty')

if [ -z "$WINDOW_TITLE" ]; then
    sketchybar --set $NAME label=""
else
    # Truncate long titles
    if [ ${#WINDOW_TITLE} -gt 50 ]; then
        WINDOW_TITLE="${WINDOW_TITLE:0:47}..."
    fi
    sketchybar --set $NAME label="$WINDOW_TITLE"
fi
