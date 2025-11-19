#!/usr/bin/env bash

# Neovim packpath (adjust if you keep plugins elsewhere)
PACKPATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack"

echo "canning for plugins without .git directories in: $PACKPATH"
echo

# Find plugin directories that don't have a .git folder
BROKEN_PLUGINS=$(find "$PACKPATH" -mindepth 2 -maxdepth 3 -type d \( -path "*/start/*" -o -path "*/opt/*" \) ! -exec test -d "{}/.git" \; -print)

if [ -z "$BROKEN_PLUGINS" ]; then
    echo "No broken plugins found (all have .git)"
    exit 0
fi

echo "Found the following plugins missing .git:"
echo "$BROKEN_PLUGINS"
echo

read -p "Do you want to delete these plugins? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "$BROKEN_PLUGINS" | xargs rm -rf
    echo "Removed broken plugins"
else
    echo "Skipped removal"
fi
