#!/bin/bash

# Hyprland Session Restorer
# Restores previously saved window layout and workspace configuration

SESSION_DIR="$HOME/.config/hypr/sessions"
SESSION_FILE="$SESSION_DIR/last_session.json"
RESTORE_LOG="$SESSION_DIR/restore.log"

# Check if session file exists
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "No session file found at $SESSION_FILE"
    exit 1
fi

echo "Restoring Hyprland session..." | tee "$RESTORE_LOG"
date | tee -a "$RESTORE_LOG"

# Read saved windows and attempt to restore them
while IFS='|' read -r workspace class title x_y size monitor; do
    # Skip comments and empty lines
    [[ $workspace =~ ^#.*$ ]] && continue
    [[ -z "$workspace" ]] && continue
    
    echo "Attempting to restore: $class on workspace $workspace" | tee -a "$RESTORE_LOG"
    
    # Parse position and size
    IFS=',' read -r x y <<< "$x_y"
    
    # Launch application based on class name
    case "$class" in
        "kitty"|"Alacritty"|"termite"|"gnome-terminal")
            hyprctl dispatch exec "$class" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "firefox"|"Firefox")
            hyprctl dispatch exec "firefox" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "app.zen_browser.zen"|"zen-browser"|"zen")
            hyprctl dispatch exec "zen-browser" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "code"|"Code"|"code-oss")
            hyprctl dispatch exec "code" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "discord"|"Discord"|"vesktop"|"Vesktop")
            hyprctl dispatch exec "vesktop" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "dolphin"|"thunar"|"nautilus"|"Thunar")
            hyprctl dispatch exec "thunar" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "steam"|"Steam")
            hyprctl dispatch exec "steam" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "obsidian"|"Obsidian")
            hyprctl dispatch exec "obsidian" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "waypaper"|"Waypaper")
            hyprctl dispatch exec "waypaper" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        "Plexamp"|"plexamp")
            hyprctl dispatch exec "plexamp" 2>&1 | tee -a "$RESTORE_LOG"
            ;;
        *)
            # Try to launch using the class name directly
            if command -v "$class" &> /dev/null; then
                hyprctl dispatch exec "$class" 2>&1 | tee -a "$RESTORE_LOG"
            else
                echo "Unknown application class: $class" | tee -a "$RESTORE_LOG"
            fi
            ;;
    esac
    
    # Small delay to allow window to spawn
    sleep 0.5
    
done < <(grep -v "^#" "$SESSION_DIR/windows.txt" | grep -v "^$")

echo "Waiting for windows to spawn..."
sleep 3

# Move windows to their correct workspaces and positions
echo "Positioning windows..." | tee -a "$RESTORE_LOG"

# Read the JSON data and restore window positions
jq -c '.[]' "$SESSION_FILE" | while read -r window; do
    workspace=$(echo "$window" | jq -r '.workspace.id')
    class=$(echo "$window" | jq -r '.class')
    x=$(echo "$window" | jq -r '.at[0]')
    y=$(echo "$window" | jq -r '.at[1]')
    width=$(echo "$window" | jq -r '.size[0]')
    height=$(echo "$window" | jq -r '.size[1]')
    
    echo "Moving $class to workspace $workspace at ${x},${y}" | tee -a "$RESTORE_LOG"
    
    # Find the window by class and move it
    window_address=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$class\") | .address" | head -1)
    
    if [[ -n "$window_address" && "$window_address" != "null" ]]; then
        # Move to correct workspace
        hyprctl dispatch movetoworkspacesilent "$workspace,address:$window_address" 2>&1 | tee -a "$RESTORE_LOG"
        
        # Move to correct position (optional, comment out if too disruptive)
        # hyprctl dispatch movewindowpixel "exact $x $y,address:$window_address" 2>&1 | tee -a "$RESTORE_LOG"
        
        # Resize window (optional)
        # hyprctl dispatch resizewindowpixel "exact $width $height,address:$window_address" 2>&1 | tee -a "$RESTORE_LOG"
    fi
    
    sleep 0.2
done

# Restore active workspace
if [[ -f "$SESSION_DIR/active_workspace.json" ]]; then
    active_workspace=$(jq -r '.id' "$SESSION_DIR/active_workspace.json")
    echo "Switching to workspace $active_workspace" | tee -a "$RESTORE_LOG"
    hyprctl dispatch workspace "$active_workspace" 2>&1 | tee -a "$RESTORE_LOG"
fi

echo "Session restoration complete!" | tee -a "$RESTORE_LOG"