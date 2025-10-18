#!/bin/bash

# Wallpaper Change Watcher
# Monitors hyprpaper config and automatically applies color schemes

CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
LAST_WALLPAPER=""

# Function to extract current wallpaper from config
get_current_wallpaper() {
    grep -m1 "^preload = " "$CONFIG_FILE" | sed 's/^preload = //' | sed "s|^~|$HOME|"
}

# Function to apply color schemes
apply_color_schemes() {
    local wallpaper="$1"

    if [[ ! -f "$wallpaper" ]]; then
        echo "Warning: Wallpaper file not found: $wallpaper"
        return 1
    fi

    echo "Detected wallpaper change: $(basename "$wallpaper")"

    # Run wallust
    if command -v wallust >/dev/null 2>&1; then
        echo "Running wallust..."
        wallust run "$wallpaper" 2>&1 | head -n 5
    else
        echo "Warning: wallust not found"
    fi

    # Run matugen
    if command -v matugen >/dev/null 2>&1; then
        echo "Running matugen..."
        matugen image "$wallpaper" 2>&1 | head -n 5
    else
        echo "Warning: matugen not found"
    fi

    # Run pywal
    if command -v wal >/dev/null 2>&1; then
        echo "Running pywal..."
        wal -i "$wallpaper" -n -q
    else
        echo "Warning: pywal (wal) not found"
    fi

    # Reload waybar to apply new colors
    if pgrep waybar >/dev/null 2>&1; then
        echo "Reloading waybar..."
        pkill waybar && sleep 0.3 && waybar > /tmp/waybar.log 2>&1 &
    fi

    echo "Color schemes updated successfully!"
}

# Initial check
if [[ -f "$CONFIG_FILE" ]]; then
    LAST_WALLPAPER=$(get_current_wallpaper)
    echo "Wallpaper watcher started"
    echo "Monitoring: $CONFIG_FILE"
    echo "Current wallpaper: $LAST_WALLPAPER"
else
    echo "Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

# Monitor config file for changes
while true; do
    inotifywait -e modify,close_write "$CONFIG_FILE" 2>/dev/null

    # Small delay to ensure file is fully written
    sleep 0.2

    CURRENT_WALLPAPER=$(get_current_wallpaper)

    # Check if wallpaper actually changed
    if [[ "$CURRENT_WALLPAPER" != "$LAST_WALLPAPER" ]] && [[ -n "$CURRENT_WALLPAPER" ]]; then
        apply_color_schemes "$CURRENT_WALLPAPER"
        LAST_WALLPAPER="$CURRENT_WALLPAPER"
    fi
done
