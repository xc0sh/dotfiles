#!/usr/bin/env bash

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat "$HOME"/.config/xcloud/settings/launcher 2>/dev/null)

# Use the native Quickshell launcher (P2.1, opt-in)
_launch_quickshell() {
    qs ipc call launcher toggle
}

# Use Rofi (default)
_launch_rofi() {
    pkill rofi || rofi -show drun -replace -i
}

if [ "$launcher" == "quickshell" ]; then
    _launch_quickshell
else
    _launch_rofi
fi
