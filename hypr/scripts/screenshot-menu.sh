#!/bin/bash

# Mac-style screenshot/recording menu
# Mimics Cmd+Shift+5 behavior

# Check if recording is already running
if pgrep wf-recorder > /dev/null; then
    # Recording is running - show stop option
    choice=$(echo -e "⏹️ Stop Recording\n📷 Screenshot Fullscreen\n📸 Screenshot Region\n❌ Cancel" | rofi -dmenu -p "Recording Active - Screenshot/Recording Menu:")
    
    case "$choice" in
        "⏹️ Stop Recording")
            pkill wf-recorder
            notify-send "Recording stopped" "Recording saved to Pictures/Recordings"
            ;;
        "📷 Screenshot Fullscreen")
            grim ~/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png
            notify-send "Screenshot saved" "Fullscreen screenshot saved to Pictures/Screenshots"
            ;;
        "📸 Screenshot Region")
            grim -g "$(slurp)" ~/Pictures/Screenshots/screenshot_region_$(date +%Y%m%d_%H%M%S).png
            notify-send "Screenshot saved" "Region screenshot saved to Pictures/Screenshots"
            ;;
        *)
            exit 0
            ;;
    esac
else
    # No recording running - show all options
    choice=$(echo -e "📷 Screenshot Fullscreen\n📸 Screenshot Region\n🎥 Record Fullscreen\n🎬 Record Region\n❌ Cancel" | rofi -dmenu -p "Screenshot/Recording Menu:")

    case "$choice" in
        "📷 Screenshot Fullscreen")
            grim ~/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png
            notify-send "Screenshot saved" "Fullscreen screenshot saved to Pictures/Screenshots"
            ;;
        "📸 Screenshot Region")
            grim -g "$(slurp)" ~/Pictures/Screenshots/screenshot_region_$(date +%Y%m%d_%H%M%S).png
            notify-send "Screenshot saved" "Region screenshot saved to Pictures/Screenshots"
            ;;
        "🎥 Record Fullscreen")
            wf-recorder -f ~/Pictures/Recordings/recording_$(date +%Y%m%d_%H%M%S).mp4 &
            notify-send "Recording started" "Recording fullscreen - use Alt+Shift+5 to stop"
            ;;
        "🎬 Record Region")
            wf-recorder -g "$(slurp)" -f ~/Pictures/Recordings/recording_region_$(date +%Y%m%d_%H%M%S).mp4 &
            notify-send "Recording started" "Recording region - use Alt+Shift+5 to stop"
            ;;
        *)
            exit 0
            ;;
    esac
fi