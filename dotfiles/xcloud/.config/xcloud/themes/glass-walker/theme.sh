#!/usr/bin/env bash
# xCloud Theme Glass

# Set waybar
echo "/xcloud-glass;/xcloud-glass/default" > $HOME/.config/xcloud/settings/waybar-theme.sh
$HOME/.config/waybar/launch.sh &

# Set swaync
echo '@import "themes/glass/style.css";' > $HOME/.config/swaync/style.css
swaync-client -rs

# Set launcher
echo 'walker' > $HOME/.config/xcloud/settings/launcher

# Set walker theme
echo 'glass' > $HOME/.config/xcloud/settings/walker-theme

# Set Window Border
echo -e 'local name = "default.lua"\nload_variant(name,"windows")' > $HOME/.config/hypr/conf/window.lua

# Set rofi
echo '* { border-width: 1px; }' > $HOME/.config/xcloud/settings/rofi-border.rasi

echo ":: Theme set to Glass"