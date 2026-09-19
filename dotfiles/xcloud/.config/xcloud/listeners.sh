#!/usr/bin/env bash

# Central control for xcloud's background listener scripts, backed by the
# xcloud-listener@ systemd --user template unit
# (~/.config/systemd/user/xcloud-listener@.service) instead of nohup+pgrep -
# that gets restart-on-crash and journald logging for free, and fixes
# low-bat-notification's pgrep-vs-self-match ambiguity by construction.
# Kept as a thin wrapper (not called directly as systemctl) because
# xcloud-power and autostart.lua depend on this exact CLI surface.

declare -a LISTENERS=("gtk-theme-switcher" "low-bat-notification")

is_registered() {
    local name="$1" candidate
    for candidate in "${LISTENERS[@]}"; do
        [[ "$candidate" == "$name" ]] && return 0
    done
    return 1
}

unit_name() { echo "xcloud-listener@$1.service"; }

require_registered() {
    if ! is_registered "$1"; then
        echo "Error: Listener '$1' is not registered."
        return 1
    fi
}

start_listener()   { require_registered "$1" && systemctl --user start "$(unit_name "$1")"; }
stop_listener()    { require_registered "$1" && systemctl --user stop "$(unit_name "$1")"; }
restart_listener() { require_registered "$1" && systemctl --user restart "$(unit_name "$1")"; }
status_listener()  { require_registered "$1" && systemctl --user status "$(unit_name "$1")"; }

usage() {
    echo "Usage: $0 [--startall | --stopall | --restartall | --statusall |"
    echo "           --start <listener_name> | --stop <listener_name> |"
    echo "           --restart <listener_name> | --status <listener_name>]"
    echo ""
    echo "Registered listeners:"
    for name in "${LISTENERS[@]}"; do
        echo "  - $name"
    done
}

case "$1" in
--startall)
    echo "Starting all registered listeners..."
    for name in "${LISTENERS[@]}"; do start_listener "$name"; done
    echo "All registered listeners processed."
    ;;
--stopall)
    echo "Stopping all registered listeners..."
    for name in "${LISTENERS[@]}"; do stop_listener "$name"; done
    echo "All registered listeners processed."
    ;;
--restartall)
    echo "Restarting all registered listeners..."
    for name in "${LISTENERS[@]}"; do restart_listener "$name"; done
    echo "All registered listeners processed."
    ;;
--statusall)
    for name in "${LISTENERS[@]}"; do status_listener "$name"; done
    ;;
--start)
    if [ -z "$2" ]; then
        echo "Error: Missing listener name for --start option."
        echo "Usage: $0 --start <listener_name>"
        exit 1
    fi
    start_listener "$2"
    ;;
--stop)
    if [ -z "$2" ]; then
        echo "Error: Missing listener name for --stop option."
        echo "Usage: $0 --stop <listener_name>"
        exit 1
    fi
    stop_listener "$2"
    ;;
--restart)
    if [ -z "$2" ]; then
        echo "Error: Missing listener name for --restart option."
        echo "Usage: $0 --restart <listener_name>"
        exit 1
    fi
    restart_listener "$2"
    ;;
--status)
    if [ -z "$2" ]; then
        echo "Error: Missing listener name for --status option."
        echo "Usage: $0 --status <listener_name>"
        exit 1
    fi
    status_listener "$2"
    ;;
*)
    usage
    exit 1
    ;;
esac
