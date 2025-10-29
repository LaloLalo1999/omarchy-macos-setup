#!/bin/bash

# Colors
BLUE=0xff89b4fa
GREY=0xff6c7086
WHITE=0xffcdd6f4
BLACK=0xff1e1e2e

if [ "$SELECTED" = "true" ]; then
    sketchybar --set $NAME \
        background.color=$BLUE \
        icon.color=$BLACK \
        label.color=$BLACK
else
    sketchybar --set $NAME \
        background.color=$BLACK \
        icon.color=$WHITE \
        label.color=$WHITE
fi
