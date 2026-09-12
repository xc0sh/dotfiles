#!/usr/bin/env bash
#     _    _ _  __ _             _
#    / \  | | |/ _| | ___   __ _| |_
#   / _ \ | | | |_| |/ _ \ / _` | __|
#  / ___ \| | |  _| | (_) | (_| | |_
# /_/   \_\_|_|_| |_|\___/ \__,_|\__|
#

hyprctl dispatch workspaceopt allfloat

# Notifications
# shellcheck disable=SC1091 # sourced at runtime via $HOME; not resolvable statically
source "$HOME/.config/xcloud/scripts/xcloud-notification-handler"

notify_user \
        --a "System" \
        --m "Windows on this workspace toggled to floating/tiling"
