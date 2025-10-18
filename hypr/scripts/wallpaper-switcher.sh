#!/bin/bash

# Pywal Wallpaper Switcher
# Interactive wallpaper selector with live preview and pywal integration

WALLPAPER_DIR="$HOME/Pictures"
CACHE_DIR="$HOME/.cache/wal"
PREVIEW_SIZE="800x600"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Function to get wallpapers (recursive search)
get_wallpapers() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" \) 2>/dev/null | sort
}

# Function to apply wallpaper and generate colors
apply_wallpaper() {
    local wallpaper="$1"
    echo "Applying wallpaper: $(basename "$wallpaper")"

    # Generate colors with wallust
    if command -v wallust >/dev/null 2>&1; then
        echo "Generating colors with wallust..."
        wallust run "$wallpaper" 2>&1 | head -n 5
    fi

    # Generate colors with matugen
    if command -v matugen >/dev/null 2>&1; then
        echo "Generating colors with matugen..."
        matugen image "$wallpaper" 2>&1 | head -n 5
    fi

    # Generate colors with pywal
    if command -v wal >/dev/null 2>&1; then
        wal -i "$wallpaper" -n
    fi

    # Set wallpaper for Hyprland (using hyprpaper)
    if command -v hyprpaper >/dev/null 2>&1; then
        # Update hyprpaper config
        echo "preload = $wallpaper" > ~/.config/hypr/hyprpaper.conf
        echo "wallpaper = ,$wallpaper" >> ~/.config/hypr/hyprpaper.conf

        # Reload hyprpaper
        pkill hyprpaper 2>/dev/null || true
        hyprpaper &
    fi

    # Restart waybar to apply new colors
    pkill waybar 2>/dev/null && sleep 0.3 && waybar > /tmp/waybar.log 2>&1 & 2>/dev/null || true

    echo "✓ Wallpaper applied and colors generated!"
}

# Interactive mode with rofi
if command -v rofi >/dev/null 2>&1; then
    wallpapers=$(get_wallpapers)
    
    if [[ -z "$wallpapers" ]]; then
        rofi -e "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
    
    # Create menu with relative paths to show folder structure
    menu=""
    while IFS= read -r wallpaper; do
        # Show relative path from Pictures directory
        relative_path=${wallpaper#$WALLPAPER_DIR/}
        menu+="$relative_path\n"
    done <<< "$wallpapers"
    
    # Show rofi menu
    selected=$(echo -e "$menu" | rofi -dmenu -i -p "Select Wallpaper" \
        -theme-str 'window { width: 60%; }' \
        -theme-str 'listview { lines: 12; }')
    
    if [[ -n "$selected" ]]; then
        # Reconstruct full path from relative path
        selected_wallpaper="$WALLPAPER_DIR/$selected"
        if [[ -f "$selected_wallpaper" ]]; then
            apply_wallpaper "$selected_wallpaper"
        else
            rofi -e "Wallpaper not found: $selected"
        fi
    fi
else
    # Fallback: command line mode
    echo "Pywal Wallpaper Switcher"
    echo "======================="
    
    wallpapers=$(get_wallpapers)
    if [[ -z "$wallpapers" ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
    
    echo "Available wallpapers:"
    select wallpaper in $wallpapers "Random" "Exit"; do
        case $wallpaper in
            "Random")
                random_wallpaper=$(get_wallpapers | shuf -n1)
                apply_wallpaper "$random_wallpaper"
                break
                ;;
            "Exit")
                break
                ;;
            *)
                if [[ -n "$wallpaper" ]]; then
                    apply_wallpaper "$wallpaper"
                    break
                fi
                ;;
        esac
    done
fi