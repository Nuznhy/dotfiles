#!/bin/bash

DARK_WALLPAPER="/home/nuznhy/dotfiles/wallpaper/marin-rose-pine.png"
LIGHT_WALLPAPER="/home/nuznhy/dotfiles/wallpaper/marin-rose-pine-dawn.png"

CURRENT_STATE=$(qs -c noctalia-shell ipc call state all | jq -r '.settings.colorSchemes.darkMode')

echo $CURRENT_STATE
if [ "$CURRENT_STATE" = "true" ]; then
    # Currently Dark -> Switch to Light
    qs -c noctalia-shell ipc call darkMode setLight
    qs -c noctalia-shell ipc call wallpaper set "$LIGHT_WALLPAPER" "DP-2"
else
    # Currently Light -> Switch to Dark
    qs -c noctalia-shell ipc call darkMode setDark
    qs -c noctalia-shell ipc call wallpaper set "$DARK_WALLPAPER" "DP-2"
fi
