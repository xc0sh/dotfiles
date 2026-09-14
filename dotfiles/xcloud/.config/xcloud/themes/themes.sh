#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# -----------------------------------------------------
# Themes
# -----------------------------------------------------
THEME_OPTIONS=$(find "$SCRIPT_DIR" -maxdepth 1 -mindepth 1 -type d | awk -F/ '{ print $NF }')

# -----------------------------------------------------
# Start Launcher
# -----------------------------------------------------

selected_theme=$(rofi -dmenu -replace -config ~/.config/rofi/config-themes.rasi -i -no-show-icons -l 5 -width 30 <<<"$THEME_OPTIONS")

# -----------------------------------------------------
# Source selected theme
# -----------------------------------------------------

# shellcheck disable=SC1090 # dynamic path based on the selected theme
source "$HOME"/.config/xcloud/themes/"$selected_theme"/theme.sh
