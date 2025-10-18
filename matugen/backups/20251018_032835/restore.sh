#!/bin/bash
# Restore original colors before matugen

BACKUP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Restoring original colors from backup..."

cp "$BACKUP_DIR/colors.css" ~/.config/waybar/colors.css
cp "$BACKUP_DIR/kitty-colors.conf" ~/.config/kitty/kitty-colors.conf
cp "$BACKUP_DIR/theme.rasi" ~/.config/rofi/theme.rasi

# Reload apps
pkill waybar && sleep 0.3 && waybar &
echo "✓ Colors restored! Waybar reloaded."
echo "You may need to restart Kitty and Rofi to see changes."
