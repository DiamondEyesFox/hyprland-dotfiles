#!/bin/bash

# Check if rofi is running
if pgrep -x "rofi" > /dev/null; then
    # If rofi is running, kill it
    pkill rofi
else
    # If rofi is not running, start it
    rofi -show drun
fi