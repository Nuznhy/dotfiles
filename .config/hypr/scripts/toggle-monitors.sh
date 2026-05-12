#!/bin/bash

# State file to track toggle status
STATE_FILE="/tmp/hypr-monitor-toggle"

if [ -f "$STATE_FILE" ]; then
    # Switch to Setup 1 (main monitors)
    hyprctl dispatch dpms off # optional flicker fix
    hyprctl keyword monitor "DP-1, 3840x2160@240.02, 0x0, 1.25"
    hyprctl keyword monitor "DP-2, 960x640, 0x1728, 1"
    hyprctl keyword monitorvrr DP-1 true
    hyprctl keyword monitorbitdepth DP-1 10
    sleep 1
    hyprctl dispatch moveworkspacetomonitor 1 DP-1
    hyprctl dispatch moveworkspacetomonitor 2 DP-1
    hyprctl dispatch moveworkspacetomonitor 3 DP-1
    hyprctl dispatch moveworkspacetomonitor 4 DP-1
    hyprctl dispatch moveworkspacetomonitor 5 DP-1
    sleep 1
    hyprctl keyword monitor "HDMI-A-1, disabled"
    rm "$STATE_FILE"
else
    hyprctl keyword monitor "HDMI-A-1, 3840x2160@60.0, 0x0, 2"
    # hyprctl keyword monitor "HDMI-A-1, 3840x2160@60.0, 3072x648, 2"
    # hyprctl keyword monitor "HDMI-A-1, 3840x2160@60.0, 3072x648, 2"
    sleep 1
    hyprctl dispatch moveworkspacetomonitor 1 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 2 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 3 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 4 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 5 HDMI-A-1
    sleep 1
    hyprctl keyword monitor "DP-2, disabled"
    hyprctl keyword monitor "DP-1, disabled"
    touch "$STATE_FILE"
fi
