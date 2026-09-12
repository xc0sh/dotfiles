#!/usr/bin/env bash
#                                      __   
#   ___ ____ ___ _  ___ __ _  ___  ___/ /__ 
#  / _ `/ _ `/  ' \/ -_)  ' \/ _ \/ _  / -_)
#  \_, /\_,_/_/_/_/\__/_/_/_/\___/\_,_/\__/ 
# /___/                                     
# 


xcloud_cache_folder="$HOME/.cache/xcloud/hyprland-dotfiles"

# Notifications
# shellcheck disable=SC1091 # sourced at runtime via $HOME; not resolvable statically
source "$HOME/.config/xcloud/scripts/xcloud-notification-handler"
APP_NAME="System"
NOTIFICATION_ICON="joystick"

if [ -f "$HOME"/.config/xcloud/settings/gamemode-enabled ]; then
  if [ -f "$xcloud_cache_folder"/restart-wpauto ]; then
    rm "$xcloud_cache_folder"/restart-wpauto
    "$HOME"/.config/xcloud/scripts/xcloud-wallpaper-automation &
  fi
  hyprctl reload
  rm "$HOME"/.config/xcloud/settings/gamemode-enabled
  notify_user --a "${APP_NAME}" \
            --i "${NOTIFICATION_ICON}" \
            --s "Gamemode deactivated" \
            --m "Animations and blur are now enabled."
else
  if [ -f "$xcloud_cache_folder"/wallpaper-automation ]; then
    touch "$xcloud_cache_folder"/restart-wpauto
    "$HOME"/.config/xcloud/scripts/xcloud-wallpaper-automation
  fi
  hyprctl eval "activate_gamemode()"
  touch "$HOME"/.config/xcloud/settings/gamemode-enabled
  notify_user --a "${APP_NAME}" \
          --i "${NOTIFICATION_ICON}" \
          --s "Gamemode activated" \
          --m "Animations and blur are now disabled."
fi