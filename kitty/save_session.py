#!/usr/bin/env python3
"""
Kitty session saver - saves running programs and working directories
"""
import json
import subprocess
import os
from pathlib import Path

def get_kitty_windows():
    """Get all kitty windows with their info"""
    try:
        result = subprocess.run(['kitty', '@', 'ls'], capture_output=True, text=True)
        return json.loads(result.stdout)
    except:
        return []

def save_session():
    """Save current kitty session state"""
    windows = get_kitty_windows()
    session_data = {}
    
    for tab in windows:
        for window in tab.get('windows', []):
            window_id = window['id']
            workspace = window.get('wm_name', 'unknown')
            foreground_process = window.get('foreground_processes', [{}])[0]
            
            cmd = foreground_process.get('cmdline', ['kitty'])
            cwd = foreground_process.get('cwd', os.path.expanduser('~'))
            
            session_data[window_id] = {
                'workspace': workspace,
                'command': cmd,
                'cwd': cwd,
                'title': window.get('title', '')
            }
    
    session_file = Path.home() / '.config/kitty/session.json'
    with open(session_file, 'w') as f:
        json.dump(session_data, f, indent=2)
    
    print(f"Session saved to {session_file}")

if __name__ == '__main__':
    save_session()