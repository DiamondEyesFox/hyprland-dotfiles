#!/bin/bash
# Apply matugen colors from current wallpaper

# Get current wallpaper from hyprpaper
WALLPAPER=$(hyprctl hyprpaper listloaded | head -1)

if [ -n "$WALLPAPER" ]; then
    echo "Generating colors from: $WALLPAPER"
    matugen image "$WALLPAPER"
else
    echo "No wallpaper loaded in hyprpaper"
    exit 1
fi
