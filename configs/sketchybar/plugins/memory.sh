#!/bin/bash

MEMORY_USAGE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | sed 's/%//')

if [ -z "$MEMORY_USAGE" ]; then
    # Fallback method
    MEMORY_USAGE=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
    MEMORY_USAGE=$((MEMORY_USAGE * 4096 / 1024 / 1024))
fi

sketchybar --set $NAME label="${MEMORY_USAGE}%"
