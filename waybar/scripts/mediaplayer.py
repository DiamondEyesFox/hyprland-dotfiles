#!/usr/bin/env python3
import subprocess
import json
import sys

def get_player_info():
    try:
        # Get current player status
        status = subprocess.run(['playerctl', 'status'], capture_output=True, text=True).stdout.strip()
        if not status or status == "No players found":
            return None
            
        # Get track info
        artist = subprocess.run(['playerctl', 'metadata', 'artist'], capture_output=True, text=True).stdout.strip()
        title = subprocess.run(['playerctl', 'metadata', 'title'], capture_output=True, text=True).stdout.strip()
        player = subprocess.run(['playerctl', 'metadata', 'mpris:trackid'], capture_output=True, text=True).stdout.strip()
        
        # Determine icon based on player or status
        if 'spotify' in player.lower():
            icon = "spotify"
        else:
            icon = "default"
            
        # Format display text
        if artist and title:
            text = f"{artist} - {title}"
        elif title:
            text = title
        elif artist:
            text = artist
        else:
            text = "Unknown"
            
        # Truncate if too long
        if len(text) > 35:
            text = text[:32] + "..."
            
        # Add play/pause indicator
        if status == "Playing":
            text = f"▶ {text}"
        elif status == "Paused":
            text = f"⏸ {text}"
        else:
            text = f"⏹ {text}"
            
        return {
            "text": text,
            "class": f"custom-media-{status.lower()}",
            "alt": icon,
            "tooltip": f"{artist} - {title}" if artist and title else text
        }
    except subprocess.CalledProcessError:
        return None
    except FileNotFoundError:
        # playerctl not installed
        return None

def main():
    info = get_player_info()
    if info:
        print(json.dumps(info))
    else:
        # No media playing - output empty or minimal info
        print(json.dumps({
            "text": "",
            "class": "custom-media-stopped",
            "alt": "default",
            "tooltip": "No media playing"
        }))

if __name__ == "__main__":
    main()