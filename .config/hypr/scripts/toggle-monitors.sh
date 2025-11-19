#!/bin/bash

# State file to track toggle status
STATE_FILE="/tmp/hypr-monitor-toggle"

if [ -f "$STATE_FILE" ]; then
    # Switch to Setup 1 (main monitors)
    hyprctl dispatch dpms off # optional flicker fix
    hyprctl keyword monitor "DP-2, 3840x2160@143.86, 0x0, 1.6"
    hyprctl keyword monitor "DP-1, 960x640, -960x640, 1"
    hyprctl keyword monitor "HDMI-A-1, disabled"
    hyprctl hyprpaper reload ,/home/nuznhy/wallpaper/marin.png
    notify-send "Monitors: DESKTOP YAY"
    rm "$STATE_FILE"
else
    # Switch to Setup 2 (HDMI monitor only)
    hyprctl dispatch dpms off
    hyprctl keyword monitor "DP-2, disabled"
    hyprctl keyword monitor "DP-1, disabled"
    hyprctl keyword monitor "HDMI-A-1, 3840x2160@60.0, 0x0, 2"
    hyprctl hyprpaper reload ,/home/nuznhy/wallpaper/hyprtv.jpg
    pkill discord
    pkill Telegram
    pkill ghostty
    pkill zen-browser
    pkill spotify
    notify-send "Monitors: TV :3" 
    touch "$STATE_FILE"
fi
