#!/usr/bin/env bash
#    ___                    
#   / _ \___ _    _____ ____
#  / ___/ _ \ |/|/ / -_) __/
# /_/   \___/__,__/\__/_/   
#                           

terminate_clients() {
  	TIMEOUT=5
	# Get a list of all client PIDs in the current Hyprland session
	client_pids=$(hyprctl clients -j | jq -r '.[] | .pid')

	# Send SIGTERM (kill -15) to each client PID and wait for termination
	for pid in $client_pids; do
		echo ":: Sending SIGTERM to PID $pid"
		kill -15 "$pid"
	done

	start_time=$(date +%s)
	for pid in $client_pids; do
		# Wait for the process to terminate
		while kill -0 "$pid" 2>/dev/null; do
		current_time=$(date +%s)
		elapsed_time=$((current_time - start_time))

		if [ $elapsed_time -ge $TIMEOUT ]; then
			echo ":: Timeout reached."
			return 0
		fi

		echo ":: Waiting for PID $pid to terminate..."
		sleep 1
		done

		echo ":: PID $pid has terminated."
	done
	bash "$HOME"/.config/xcloud/listeners.sh --stopall
	terminate_background_daemons
}

# Layer-shell surfaces and standalone daemons (waybar, the Quickshell shell,
# swaync, hypridle, the wallpaper daemon, the cliphist watcher, the polkit
# agent) have no toplevel window, so `hyprctl clients` never lists them --
# the SIGTERM loop above can't reach them. Left running across a logout,
# they hold onto sockets/D-Bus names/cursor themes that the next session's
# copies of the same daemons then collide with, which is what actually
# freezes a re-login rather than starting cleanly. Mirrors the `killall qs`
# already used by xcloud-autostart on startup for the same reason.
terminate_background_daemons() {
	echo ":: Stopping background daemons"
	killall qs 2>/dev/null
	pkill -x waybar 2>/dev/null
	pkill -x swaync 2>/dev/null
	pkill -x hypridle 2>/dev/null
	pkill -x awww-daemon 2>/dev/null
	pkill -x wl-paste 2>/dev/null
	pkill -f polkit-gnome-authentication-agent 2>/dev/null
	# Same class of gap: these are long-running background loops (wallpaper
	# rotation, day/night hyprsunset scheduling, coffee mode's re-enable
	# timer) with no toplevel window either, and logind's default
	# KillUserProcesses=no means they'd otherwise survive a logout.
	pkill -f xcloud-wallpaper-automation 2>/dev/null
	pkill -f xcloud-hyprsunset-scheduler 2>/dev/null
	pkill -f xcloud-coffee-mode 2>/dev/null
	return 0
}

if [[ "$1" == "exit" ]]; then
	echo ":: Exit"
	terminate_clients
	sleep 0.5
	hyprctl dispatch "hl.dsp.exit()"
	sleep 2
fi

if [[ "$1" == "lock" ]]; then
	echo ":: Lock"
	sleep 0.5
	hyprlock
fi

if [[ "$1" == "reboot" ]]; then
	echo ":: Reboot"
	terminate_clients
	sleep 0.5
	systemctl reboot
fi

if [[ "$1" == "shutdown" ]]; then
	echo ":: Shutdown"
	terminate_clients
	sleep 0.5
	systemctl poweroff
fi

if [[ "$1" == "suspend" ]]; then
	echo ":: Suspend"
	sleep 0.5
	systemctl suspend
fi

if [[ "$1" == "hibernate" ]]; then
	echo ":: Hibernate"
	sleep 1
	systemctl hibernate
fi
