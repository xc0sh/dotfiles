#!/usr/bin/env bash

# Notifications
# shellcheck disable=SC1091 # sourced at runtime via $HOME; not resolvable statically
source "$HOME/.config/xcloud/scripts/xcloud-notification-handler"

killall hypridle
sleep 1
hypridle &

notify_user --a "Hypridle" \
        --s "Hypridle has been restarted." \
        --m ""
