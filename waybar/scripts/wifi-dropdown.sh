#!/bin/bash

# WiFi dropdown menu using eww for a proper popup
CONFIG_DIR="$HOME/.config/eww/wifi-menu"
LOCK_FILE="/tmp/wifi-dropdown.lock"

# Create config directory
mkdir -p "$CONFIG_DIR"

# Check if dropdown is already open
if [ -f "$LOCK_FILE" ]; then
    # Close dropdown
    eww close wifi-menu
    rm -f "$LOCK_FILE"
    exit 0
fi

# Create lock file
touch "$LOCK_FILE"

# Get mouse cursor position to position dropdown
eval $(xdotool getmouselocation --shell)

# Create eww configuration for wifi menu
cat > "$CONFIG_DIR/eww.yuck" << 'EOF'
(defwindow wifi-menu
  :monitor 0
  :geometry (geometry :x "1600px"
                      :y "50px"
                      :width "300px"
                      :height "400px"
                      :anchor "top right")
  :stacking "overlay"
  :exclusive false
  :focusable true
  (wifi-widget))

(defwidget wifi-widget []
  (box :orientation "vertical"
       :class "wifi-menu"
       :space-evenly false
    (box :class "wifi-header"
         :space-evenly false
      (label :text "WiFi Networks" :class "wifi-title")
      (button :class "close-btn"
              :onclick "eww close wifi-menu && rm -f /tmp/wifi-dropdown.lock"
              "✕"))
    (scroll :height 350
      (box :orientation "vertical"
           :space-evenly false
        (for network in networks
          (button :class "wifi-network"
                  :onclick "scripts/connect-wifi.sh '${network.ssid}' '${network.security}'"
            (box :space-evenly false
              (label :text "${network.icon}" :class "wifi-icon")
              (box :orientation "vertical"
                   :space-evenly false
                (label :text "${network.ssid}" :class "wifi-ssid" :halign "start")
                (label :text "${network.info}" :class "wifi-info" :halign "start"))
              (label :text "${network.signal}" :class "wifi-signal"))))))))

(defvar networks "[]")
EOF

# Create CSS for the dropdown
cat > "$CONFIG_DIR/eww.scss" << 'EOF'
.wifi-menu {
  background: rgba(40, 40, 40, 0.95);
  border: 2px solid #555;
  border-radius: 12px;
  padding: 16px;
  color: #fff;
  font-family: "JetBrains Mono", monospace;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
  backdrop-filter: blur(10px);
}

.wifi-header {
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid #555;
}

.wifi-title {
  font-size: 16px;
  font-weight: bold;
  flex: 1;
}

.close-btn {
  background: transparent;
  border: none;
  color: #fff;
  font-size: 14px;
  min-width: 24px;
  min-height: 24px;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.wifi-network {
  background: transparent;
  border: none;
  color: #fff;
  padding: 12px;
  margin: 2px 0;
  border-radius: 8px;
  min-height: 50px;
}

.wifi-network:hover {
  background: rgba(100, 150, 255, 0.2);
}

.wifi-icon {
  font-size: 18px;
  margin-right: 12px;
  min-width: 24px;
}

.wifi-ssid {
  font-size: 14px;
  font-weight: bold;
}

.wifi-info {
  font-size: 12px;
  color: #aaa;
}

.wifi-signal {
  font-size: 12px;
  color: #4CAF50;
}
EOF

# Create connection script
mkdir -p "$CONFIG_DIR/scripts"
cat > "$CONFIG_DIR/scripts/connect-wifi.sh" << 'EOF'
#!/bin/bash
ssid="$1"
security="$2"

if [[ "$security" == "Open" ]]; then
    nmcli device wifi connect "$ssid"
else
    password=$(rofi -dmenu -password -p "Password for $ssid:")
    if [[ -n "$password" ]]; then
        nmcli device wifi connect "$ssid" password "$password"
    fi
fi

# Close dropdown
eww close wifi-menu
rm -f /tmp/wifi-dropdown.lock
EOF
chmod +x "$CONFIG_DIR/scripts/connect-wifi.sh"

# Get WiFi networks and format as JSON
get_networks() {
    echo "["
    first=true
    nmcli -f SSID,SIGNAL,SECURITY dev wifi | tail -n +2 | while read -r line; do
        ssid=$(echo "$line" | awk '{print $1}')
        signal=$(echo "$line" | awk '{print $2}')
        security=$(echo "$line" | awk '{print $3}')
        
        if [[ -n "$ssid" && "$ssid" != "--" ]]; then
            if [[ "$security" == "--" ]]; then
                security="Open"
                icon="📡"
            else
                security="Secured"
                icon="🔒"
            fi
            
            if [[ "$first" != "true" ]]; then
                echo ","
            fi
            first=false
            echo "{\"ssid\": \"$ssid\", \"signal\": \"$signal%\", \"security\": \"$security\", \"icon\": \"$icon\", \"info\": \"$security\"}"
        fi
    done
    echo "]"
}

# Update networks variable and show dropdown
networks=$(get_networks)
eww -c "$CONFIG_DIR" update networks="$networks"
eww -c "$CONFIG_DIR" open wifi-menu

# Auto-close after 30 seconds
(sleep 30; eww close wifi-menu; rm -f "$LOCK_FILE") &
EOF