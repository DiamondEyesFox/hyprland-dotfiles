#!/bin/bash

# Workspace overview script for Hyprland
# Shows all workspaces and their windows in a visual rofi menu

# Get workspace info from hyprctl
workspaces=$(hyprctl workspaces -j | jq -r '.[] | "\(.id):\(.name)"' | sort -n)
windows=$(hyprctl clients -j | jq -r '.[] | "\(.workspace.id):\(.class):\(.title)"')

# Create workspace overview data
overview=""
declare -A workspace_windows

# Parse windows into workspaces
while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        ws_id=$(echo "$line" | cut -d':' -f1)
        class=$(echo "$line" | cut -d':' -f2)
        title=$(echo "$line" | cut -d':' -f3)
        
        # Limit title length
        short_title=$(echo "$title" | cut -c1-30)
        if [[ ${#title} -gt 30 ]]; then
            short_title="${short_title}..."
        fi
        
        if [[ -n "${workspace_windows[$ws_id]}" ]]; then
            workspace_windows[$ws_id]+=" │ $class: $short_title"
        else
            workspace_windows[$ws_id]="$class: $short_title"
        fi
    fi
done <<< "$windows"

# Build overview menu
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')
for i in {1..10}; do
    indicator=" "
    if [[ "$i" == "$current_ws" ]]; then
        indicator=""  # Current workspace indicator
    fi
    
    if [[ -n "${workspace_windows[$i]}" ]]; then
        overview+="$indicator Workspace $i: ${workspace_windows[$i]}\n"
    else
        overview+="$indicator Workspace $i: Empty\n"
    fi
done

# Show rofi menu and get selection
selected=$(echo -e "$overview" | rofi -dmenu -i -p "Workspace Overview" \
    -theme-str 'window { width: 80%; }' \
    -theme-str 'listview { lines: 10; }' \
    -format 'i')

# Switch to selected workspace (rofi returns index starting from 0)
if [[ -n "$selected" ]]; then
    target_ws=$((selected + 1))
    hyprctl dispatch workspace $target_ws
fi