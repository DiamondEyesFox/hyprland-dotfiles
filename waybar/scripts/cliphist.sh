#!/bin/bash

case "$1" in
    "d")
        # Delete clipboard history
        cliphist wipe
        ;;
    "w")
        # Clear current clipboard
        wl-copy ""
        ;;
    *)
        # Show clipboard history with rofi
        cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy
        ;;
esac