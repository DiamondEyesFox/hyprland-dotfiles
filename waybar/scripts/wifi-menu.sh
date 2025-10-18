#!/bin/bash

# WiFi dropdown menu for Waybar using rofi
# Shows available networks and allows connection

get_wifi_status() {
    if nmcli radio wifi | grep -q "enabled"; then
        current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
        if [[ -n "$current_ssid" ]]; then
            signal=$(nmcli -f IN-USE,SIGNAL dev wifi | grep '*' | awk '{print $2}')
            echo "Connected: $current_ssid ($signal%)"
        else
            echo "WiFi enabled, not connected"
        fi
    else
        echo "WiFi disabled"
    fi
}

show_wifi_menu() {
    # Get current status
    status=$(get_wifi_status)
    
    # Build menu options
    options="📡 WiFi Status: $status\n"
    
    if nmcli radio wifi | grep -q "enabled"; then
        options+="🔄 Refresh Networks\n"
        options+="❌ Turn Off WiFi\n"
        options+="───────────────────\n"
        
        # Get available networks
        networks=$(nmcli -f SSID,SIGNAL,SECURITY dev wifi | grep -v '^$' | tail -n +2 | sort -k2 -nr | head -15)
        
        while IFS= read -r network; do
            ssid=$(echo "$network" | awk '{print $1}')
            signal=$(echo "$network" | awk '{print $2}')
            security=$(echo "$network" | awk '{print $3}')
            
            if [[ -n "$ssid" && "$ssid" != "--" ]]; then
                if [[ "$security" == "--" ]]; then
                    options+="📶 $ssid ($signal%) [Open]\n"
                else
                    options+="🔒 $ssid ($signal%) [Secured]\n"
                fi
            fi
        done <<< "$networks"
    else
        options+="✅ Turn On WiFi\n"
    fi
    
    options+="───────────────────\n🛠️ Open Network Settings"
    
    # Show menu
    choice=$(echo -e "$options" | rofi -dmenu -i -p "WiFi Networks:" -lines 20)
    
    if [[ -z "$choice" ]]; then
        exit 0
    fi
    
    # Handle selection
    case "$choice" in
        *"Turn On WiFi"*)
            nmcli radio wifi on
            notify-send "WiFi" "WiFi enabled"
            ;;
        *"Turn Off WiFi"*)
            nmcli radio wifi off
            notify-send "WiFi" "WiFi disabled"
            ;;
        *"Refresh Networks"*)
            nmcli device wifi rescan
            notify-send "WiFi" "Scanning for networks..."
            sleep 2
            show_wifi_menu
            ;;
        *"Open Network Settings"*)
            kitty nmtui &
            ;;
        📶*|🔒*)
            # Extract SSID from selection
            ssid=$(echo "$choice" | sed 's/^[📶🔒] //' | sed 's/ ([0-9]*%) \[.*\]$//')
            
            if nmcli -f SSID dev wifi | grep -q "^$ssid$"; then
                if echo "$choice" | grep -q "\[Open\]"; then
                    # Open network
                    if nmcli device wifi connect "$ssid"; then
                        notify-send "WiFi" "Connected to $ssid"
                    else
                        notify-send "WiFi" "Failed to connect to $ssid"
                    fi
                else
                    # Secured network - prompt for password
                    password=$(rofi -dmenu -password -p "Password for $ssid:")
                    if [[ -n "$password" ]]; then
                        if nmcli device wifi connect "$ssid" password "$password"; then
                            notify-send "WiFi" "Connected to $ssid"
                        else
                            notify-send "WiFi" "Failed to connect to $ssid"
                        fi
                    fi
                fi
            fi
            ;;
    esac
}

show_wifi_menu