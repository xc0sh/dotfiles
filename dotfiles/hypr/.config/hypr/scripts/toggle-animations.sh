#!/usr/bin/env bash
# hyprctl keyword doesn't work under this Lua-config's non-legacy parser
# ("keyword can't work with non-legacy parsers. Use eval.") -- hl.config()
# via hyprctl eval is the working equivalent (same pattern gamemode.sh uses).
cache_file="$HOME/.cache/toggle_animation"
if [ -f "$cache_file" ]; then
    hyprctl eval "hl.config({animations = {enabled = true}})"
    rm "$cache_file"
else
    hyprctl eval "hl.config({animations = {enabled = false}})"
    touch "$cache_file"
fi
