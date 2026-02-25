#!/bin/bash

# Target Settings
WS="1"
CLASS="com.mitchellh.ghostty"

while true; do
    # Get all windows on Workspace 1 in JSON
    DATA=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS)]")
    COUNT=$(echo "$DATA" | jq "length")

    # CASE 1: Exactly one window on Workspace 1
    if [ "$COUNT" -eq 1 ]; then
        IS_GHOSTTY=$(echo "$DATA" | jq -r ".[0].class")
        IS_FLOATING=$(echo "$DATA" | jq -r ".[0].floating")
        ADDR=$(echo "$DATA" | jq -r ".[0].address")

        if [ "$IS_GHOSTTY" == "$CLASS" ] && [ "$IS_FLOATING" == "false" ]; then
            # Apply floating, specific size, and center
            hyprctl dispatch setfloating address:$ADDR
            hyprctl dispatch resizewindowpixel exact 80% 95%,address:$ADDR
            hyprctl dispatch centerwindow address:$ADDR
        fi

    # CASE 2: More than one window (Force Tiling)
    elif [ "$COUNT" -gt 1 ]; then
        # Get addresses of all windows currently floating on Workspace 1
        FLOATING_ADDRS=$(echo "$DATA" | jq -r ".[] | select(.floating == true) | .address")
        
        for ADDR in $FLOATING_ADDRS; do
            # Correct syntax: dispatch settiled to specific window address
            hyprctl dispatch settiled address:$ADDR
        done
    fi

    sleep 0.5
done
