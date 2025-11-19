#!/bin/bash

# Ensure this is only run inside Wayland
if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
  echo "⚠️ This script must be run from a Wayland session (e.g. Hyprland)"
  exit 1
fi

# Launch Steam Big Picture inside Gamescope with MangoHud (for games only)
gamescope \
    --nested-width 3840 \
    --nested-height 2160 \
    -f \
    --steam \
    --backend sdl \
    -- \
    bash -c 'export MANGOHUD=1; steam -gamepadui'

