#!/usr/bin/env bash

WS=1
CLASS="com.mitchellh.ghostty"
SLEEP_TIME=1

dispatch_float() {
    local addr="$1"

    hyprctl dispatch "hl.dsp.window.float({ action = 'enable', window = 'address:${addr}' })" >/dev/null
    hyprctl dispatch "hl.dsp.window.resize({ x = '80%', y = '95%', window = 'address:${addr}' })" >/dev/null
    hyprctl dispatch "hl.dsp.window.center({ window = 'address:${addr}' })" >/dev/null
}

dispatch_tile() {
    local addr="$1"

    hyprctl dispatch "hl.dsp.window.float({ action = 'disable', window = 'address:${addr}' })" >/dev/null
}

while true; do
    DATA="$(hyprctl clients -j 2>/dev/null)"

    echo "$DATA" | jq empty 2>/dev/null || {
        sleep "$SLEEP_TIME"
        continue
    }

    DATA="$(echo "$DATA" | jq --argjson ws "$WS" '[.[] | select(.workspace.id == $ws)]')"
    COUNT="$(echo "$DATA" | jq 'length')"

    if [ "$COUNT" -eq 1 ]; then
        CLASSNAME="$(echo "$DATA" | jq -r '.[0].class')"
        ADDR="$(echo "$DATA" | jq -r '.[0].address')"
        IS_FLOATING="$(echo "$DATA" | jq -r '.[0].floating')"

        if [ "$CLASSNAME" = "$CLASS" ]; then
            dispatch_float "$ADDR"
        fi

    elif [ "$COUNT" -gt 1 ]; then
        FLOATING_ADDRS="$(echo "$DATA" | jq -r '.[] | select(.floating == true) | .address')"

        for ADDR in $FLOATING_ADDRS; do
            dispatch_tile "$ADDR"
        done
    fi

    sleep "$SLEEP_TIME"
done
