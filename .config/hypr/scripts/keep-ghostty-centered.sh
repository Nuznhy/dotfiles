#!/bin/bash

# Target Settings
WS="1"
CLASS="com.mitchellh.ghostty"

while true; do
    # Get all windows on Workspace 1 in JSON
    DATA=$(hyprctl clients -j 2>/dev/null)

    # skip if output invalid
    echo "$DATA" | jq empty 2>/dev/null || { sleep 1; continue; }

    DATA=$(echo "$DATA" | jq "[.[] | select(.workspace.id == $WS)]")
    COUNT=$(echo "$DATA" | jq "length")

    # CASE 1: Exactly one window on Workspace 1
    if [ "$COUNT" -eq 1 ]; then
        CLASSNAME=$(echo "$DATA" | jq -r ".[0].class")
        ADDR=$(echo "$DATA" | jq -r ".[0].address")

        if [ "$CLASSNAME" == "$CLASS" ]; then
            hyprctl dispatch setfloating address:$ADDR
            hyprctl dispatch resizewindowpixel exact 80% 95% address:$ADDR
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

    sleep 1
done
