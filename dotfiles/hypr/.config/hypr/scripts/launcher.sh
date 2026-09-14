#!/usr/bin/env bash

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------

# Use Rofi
_launch_rofi() {
    pkill rofi || rofi -show drun -replace -i
}

_launch_rofi
