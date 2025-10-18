#!/bin/bash
# Visual wallpaper gallery with thumbnails
# Navigate with arrows, press Enter on any image to instantly apply

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Check if swww daemon is running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

cd "$WALLPAPER_DIR" || exit

# Show instructions
notify-send "Wallpaper Gallery" "Navigate with arrows\nPress ENTER or SPACE to apply\nPress 'q' to quit" -t 3000

# Use nsxiv in thumbnail mode
# nsxiv with -o prints the current image when you press Enter or mark with Space then quit
# We'll use a wrapper approach: pipe through a while loop that applies immediately

while true; do
    # Launch nsxiv and get selection (Enter or Space+q works)
    SELECTED=$(nsxiv -t -o . 2>/dev/null | head -1)

    # If nothing selected (user pressed 'q' without selecting), exit
    if [ -z "$SELECTED" ]; then
        break
    fi

    # Set wallpaper with swww (use full path)
    FULLPATH="$WALLPAPER_DIR/$SELECTED"
    swww img "$FULLPATH" \
        --transition-type random \
        --transition-duration 1.0 \
        --transition-fps 144 \
        --transition-step 90 \
        --transition-bezier 0.25,0.1,0.25,1.0

    # Save as current wallpaper
    ln -sf "$FULLPATH" "$WALLPAPER_DIR/current.jpg"

    notify-send "Wallpaper Applied" "$(basename "$SELECTED")" -t 1500

    # Exit after applying (remove 'break' if you want gallery to stay open)
    break
done
