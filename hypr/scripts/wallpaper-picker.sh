#!/bin/bash
# Fast wallpaper picker using swww and rofi/fzf

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Create wallpaper dir if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Check if swww daemon is running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Get all image files
cd "$WALLPAPER_DIR" || exit
WALLPAPERS=$(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sed 's|^\./||' | sort)

if [ -z "$WALLPAPERS" ]; then
    notify-send "No wallpapers found" "Add images to $WALLPAPER_DIR"
    exit 1
fi

# Use rofi to select wallpaper
SELECTED=$(echo "$WALLPAPERS" | rofi -dmenu -i -p "Select Wallpaper" -theme-str 'window {width: 50%;}')

if [ -n "$SELECTED" ]; then
    # Set wallpaper with swww
    swww img "$WALLPAPER_DIR/$SELECTED" \
        --transition-type fade \
        --transition-duration 1 \
        --transition-fps 60

    # Save as current wallpaper
    ln -sf "$WALLPAPER_DIR/$SELECTED" "$WALLPAPER_DIR/current.jpg"

    notify-send "Wallpaper Changed" "$SELECTED"
fi
