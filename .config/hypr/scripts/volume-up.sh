#!/bin/bash

STEP=5
MAX=100

# Get current volume (pulse) for default sink
current=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F '/' '{print $2}' | grep -o '[0-9]\+')

if [ "$current" -lt "$MAX" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ +${STEP}%
fi
