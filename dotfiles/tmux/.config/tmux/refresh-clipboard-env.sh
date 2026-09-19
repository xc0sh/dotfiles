#!/usr/bin/env bash

# Refreshes the tmux SERVER's WAYLAND_DISPLAY/XDG_RUNTIME_DIR/
# DBUS_SESSION_BUS_ADDRESS from systemd --user's own (live) activation
# environment. Run from a pane-focus-in hook (see .tmux.conf).
#
# Why this exists: every clipboard/link-opening path out of tmux (wl-copy,
# wl-paste, xdg-open) runs as a tmux *job* (copy-pipe, run-shell, tmux-
# thumbs' --command), and jobs inherit the SERVER's environment, not the
# attached client's or the pane's. tmux's own `update-environment`
# (WAYLAND_DISPLAY, set further up in .tmux.conf) only pushes a value into
# a *session* when a client attaches -- it does nothing for a long-lived
# server's job environment, and does nothing at all if no client ever
# reattaches after a compositor restart (e.g. tmux kept alive by
# tmux-continuum). A server that outlives one of those restarts silently
# keeps stale values forever, and every path above starts silently no-op'ing
# (setsid -f wl-copy/wl-paste's own errors are suppressed by design -- see
# the binds in .tmux.conf -- so this fails with zero visible signal).
#
# systemd --user's environment is the one thing Hyprland's own autostart
# (dbus-update-activation-environment, hypr/conf/autostart.lua) actively
# re-pushes on every real session start, so it's always current -- reading
# it here on every pane focus keeps the server's env in step without
# needing to guess whether a restart happened.

env_snapshot=$(systemctl --user show-environment 2>/dev/null)
for var in WAYLAND_DISPLAY XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS; do
    value=$(sed -n "s/^${var}=//p" <<< "$env_snapshot")
    [ -n "$value" ] && tmux set-environment -g "$var" "$value"
done
