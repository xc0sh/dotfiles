#!/usr/bin/env bash
#                                 __        __
#   ___ ___________ ___ ___  ___ / /  ___  / /_
#  (_-</ __/ __/ -_) -_) _ \(_-</ _ \/ _ \/ __/
# /___/\__/_/  \__/\__/_//_/___/_//_/\___/\__/
#
# Rofi menu/flow originally based on
# https://github.com/hyprwm/contrib/blob/main/grimblast/screenshot.sh, but no
# longer depends on grimblast itself (an AUR/source-build-only tool) -- the
# actual capture now goes through hyprshot+satty (both in Arch's official
# `extra` repo) for "output"/"area" modes, and plain grim (as before) for
# "screen" (all-outputs) mode, which hyprshot itself has no equivalent for.

# -----------------------------------------------------

# Screenshots will be stored in $HOME by default.
# The screenshot will be moved into the screenshot directory

# Defaults
SAVE_DIR="$HOME/Pictures"
SAVE_FILENAME="screenshot_$(date +%d%m%Y_%H%M%S).jpg"

# Load Settings
if [ -f ~/.config/xcloud/settings/screenshot-folder ]; then
    SAVE_DIR=$(cat ~/.config/xcloud/settings/screenshot-folder)
fi
if [ -f ~/.config/xcloud/settings/screenshot-filename ]; then
    SAVE_FILENAME=$(cat ~/.config/xcloud/settings/screenshot-filename)
fi

eval screenshot_folder="$SAVE_DIR"
eval NAME="$SAVE_FILENAME"

# Get image format
image_format="png"
extension="${NAME##*.}"

case $extension in
    "jpg"|"jpeg")
        image_format="jpeg"
        ;;
    "ppm")
        image_format="ppm"
        ;;
esac

# Notifications
# shellcheck disable=SC1091 # sourced at runtime via $HOME; not resolvable statically
source "$HOME/.config/xcloud/scripts/xcloud-notification-handler"
APP_NAME="Screen Capture"
NOTIFICATION_ICON="camera-photo-symbolic"

# Quick instant mode: full screen
take_instant_full() {
    # shellcheck disable=SC2154 # screenshot_folder assigned above via eval, opaque to static analysis
    grim -t "$image_format" "$NAME" && notify_user \
        --a "${APP_NAME}" \
        --i "${NOTIFICATION_ICON}" \
        --s "Screenshot saved" \
        --m "$screenshot_folder/$NAME" \
        --t 1000

    [[ -f "$HOME/$NAME" && -d "$screenshot_folder" && -w "$screenshot_folder" ]] && mv "$HOME/$NAME" "$screenshot_folder/"
}

# Quick instant mode: area selection
take_instant_area() {
    local pid_picker region

    # freeze screen for region selection
    hyprpicker -r -z &
    pid_picker=$!
    trap 'kill "$pid_picker" 2>/dev/null' EXIT
    sleep 0.1

    # user selects region; kill picker on cancel
    region=$(slurp -b "#00000080" -c "#888888ff" -w 1) || exit 0
    [[ -z "$region" ]] && exit 0

    # unfreeze screen
    kill "$pid_picker" 2>/dev/null
    trap - EXIT

    # capture and notify
    grim -g "$region" -t "$image_format" "$NAME" && notify_user \
        --a "${APP_NAME}" \
        --i "${NOTIFICATION_ICON}" \
        --s "Screenshot saved" \
        --m "$screenshot_folder/$NAME" \
        --t 1000
    [[ -f "$HOME/$NAME" && -d "$screenshot_folder" && -w "$screenshot_folder" ]] && mv "$HOME/$NAME" "$screenshot_folder/"
}

# Handle instant flags
if [[ "$1" == "--instant" ]]; then
    take_instant_full
    exit 0
elif [[ "$1" == "--instant-area" ]]; then
    take_instant_area
    exit 0
fi

# Options
option_1="Immediate"
option_2="Delayed"

option_capture_1="Capture Everything"
option_capture_2="Capture Active Display"
option_capture_3="Capture Selection"

option_time_1="5s"
option_time_2="10s"
option_time_3="20s"
option_time_4="30s"
option_time_5="60s"
#option_time_4="Custom (in seconds)" # Roadmap or someone contribute :)

copy='Copy'
save='Save'
copy_save='Copy & Save'
edit='Edit'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 2 -width 30 -p "Take screenshot"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2" | rofi_cmd
}

####
# Choose Timer
# CMD
timer_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 5 -width 30 -p "Choose timer"
}

# Ask for confirmation
timer_exit() {
    echo -e "$option_time_1\n$option_time_2\n$option_time_3\n$option_time_4\n$option_time_5" | timer_cmd
}

# Confirm and execute
# shellcheck disable=SC2120 # optional callback arg, like copy_save_editor_run below; not every caller uses it
timer_run() {
    selected_timer="$(timer_exit)"
    if [[ "$selected_timer" == "$option_time_1" ]]; then
        countdown=5
        ${1}
    elif [[ "$selected_timer" == "$option_time_2" ]]; then
        countdown=10
        ${1}
    elif [[ "$selected_timer" == "$option_time_3" ]]; then
        countdown=20
        ${1}
    elif [[ "$selected_timer" == "$option_time_4" ]]; then
        countdown=30
        ${1}
    elif [[ "$selected_timer" == "$option_time_5" ]]; then
        countdown=60
        ${1}
    else
        exit
    fi
}
###

####
# Chose Screenshot Type
# CMD
type_screenshot_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 3 -width 30 -p "Type of screenshot"
}

# Ask for confirmation
type_screenshot_exit() {
    echo -e "$option_capture_1\n$option_capture_2\n$option_capture_3" | type_screenshot_cmd
}

# Confirm and execute
# shellcheck disable=SC2120 # optional callback arg, like copy_save_editor_run below; not every caller uses it
type_screenshot_run() {
    selected_type_screenshot="$(type_screenshot_exit)"
    if [[ "$selected_type_screenshot" == "$option_capture_1" ]]; then
        option_type_screenshot=screen
        ${1}
    elif [[ "$selected_type_screenshot" == "$option_capture_2" ]]; then
        option_type_screenshot=output
        ${1}
    elif [[ "$selected_type_screenshot" == "$option_capture_3" ]]; then
        option_type_screenshot=area
        ${1}
    else
        exit
    fi
}
###

####
# Choose to save or copy photo
# CMD
copy_save_editor_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "How to save"
}

# Ask for confirmation
copy_save_editor_exit() {
    echo -e "$copy\n$save\n$copy_save\n$edit" | copy_save_editor_cmd
}

# Confirm and execute
copy_save_editor_run() {
    selected_chosen="$(copy_save_editor_exit)"
    if [[ "$selected_chosen" == "$copy" ]]; then
        option_chosen=copy
        image_format=png
        ${1}
    elif [[ "$selected_chosen" == "$save" ]]; then
        option_chosen=save
        ${1}
    elif [[ "$selected_chosen" == "$copy_save" ]]; then
        option_chosen=copysave
        image_format=png
        ${1}
    elif [[ "$selected_chosen" == "$edit" ]]; then
        option_chosen=edit
        ${1}
    else
        exit
    fi
}
###

timer() {
    if [[ $countdown -gt 10 ]]; then
        notify_user \
            --a "${APP_NAME}" \
            --i "${NOTIFICATION_ICON}" \
            --s "Taking screenshot in ${countdown} seconds" \
            --m "" \
            --t 1000
        countdown_less_10=$((countdown - 10))
        sleep $countdown_less_10
        countdown=10
    fi
    while [[ $countdown -ne 0 ]]; do
        notify_user \
            --a "${APP_NAME}" \
            --i "${NOTIFICATION_ICON}" \
            --s "Taking screenshot in ${countdown} seconds" \
            --m "" \
            --t 1000
        countdown=$((countdown - 1))
        sleep 1
    done
}

# Captures $option_type_screenshot (screen/output/area, set by
# type_screenshot_run) per $option_chosen (copy/save/copysave/edit, set by
# copy_save_editor_run), replacing what grimblast used to do in one call.
# "output"/"area" go through hyprshot for copy/save/copysave; "screen" (all
# outputs -- hyprshot has no equivalent mode for this) still uses grim
# directly, same as take_instant_full above. "edit" pipes raw image bytes
# into satty instead of the old configurable $GRIMBLAST_EDITOR (see
# screenshot-editor cleanup).
#
# Deliberately NOT using `hyprshot -r` for edit mode: hyprshot's own script
# backgrounds the actual grab (`begin_grab $OPTION & checkRunning`) and
# checkRunning exits the whole process the instant `pgrep slurp` finds
# nothing -- for `-m output` there's no slurp involved at all, so it can (and
# for a fast/no-interaction capture, likely does) exit before the backgrounded
# `grim -g ... -` finishes writing to stdout, truncating what satty reads on
# the other end of the pipe. Sidestepped entirely by calling grim directly
# for all three edit-mode branches (`_active_output_geometry` below is
# hyprshot's own `grab_active_output` geometry expression, replicated so
# "output"+edit doesn't need hyprshot's process at all).
#
# Known gap, not live-testable from here: hyprshot always names its own save
# file with a .png extension internally; if $NAME is configured with a
# .jpg/.jpeg/.ppm extension (via settings/screenshot-filename), the
# "output"/"area" copy/save/copysave paths may not honor that the way
# "screen" (plain grim, which does respect $image_format) does. Flagged for
# the first live test, not fixed blind.
_active_output_geometry() {
    local monitors active_id current
    monitors=$(hyprctl -j monitors)
    active_id=$(hyprctl -j activeworkspace | jq -r '.id')
    current=$(echo "$monitors" | jq -r --argjson id "$active_id" 'first(.[] | select(.activeWorkspace.id == $id))')
    echo "$current" | jq -r '"\(.x),\(.y) \(.width/.scale|round)x\(.height/.scale|round)"'
}

_capture() {
    local mode="$1" action="$2"

    if [[ "$action" == "edit" ]]; then
        case "$mode" in
            screen)  grim - | satty --filename - --output-filename "$screenshot_folder/$NAME" ;;
            output)  grim -g "$(_active_output_geometry)" - | satty --filename - --output-filename "$screenshot_folder/$NAME" ;;
            area)    grim -g "$(slurp -d)" - | satty --filename - --output-filename "$screenshot_folder/$NAME" ;;
        esac
        return 0
    fi

    mkdir -p "$screenshot_folder"
    case "$mode" in
        screen)
            grim -t "$image_format" "$screenshot_folder/$NAME"
            [[ "$action" == "copy" || "$action" == "copysave" ]] && wl-copy --type "image/$image_format" < "$screenshot_folder/$NAME"
            [[ "$action" == "copy" ]] && rm -f "$screenshot_folder/$NAME"
            ;;
        output)
            if [[ "$action" == "copy" ]]; then
                hyprshot -m output -m active -s --clipboard-only
            else
                hyprshot -m output -m active -s -o "$screenshot_folder" -f "$NAME"
            fi
            ;;
        area)
            if [[ "$action" == "copy" ]]; then
                hyprshot -m region -z -s --clipboard-only
            else
                hyprshot -m region -z -s -o "$screenshot_folder" -f "$NAME"
            fi
            ;;
    esac
    # Without this, _capture's own return status would be whatever the last
    # conditional check inside the case above happened to evaluate to (e.g.
    # false for a "save" that correctly skipped the copy-only branch) --
    # harmless today since nothing checks it, but wrong on its own terms.
    return 0
}

# _capture's own hyprshot/grim calls are silenced (-s, or just not sent one)
# so this is the one place notifications come from for the rofi-menu flow --
# worded per $option_chosen since "edit" hasn't saved anything yet (satty's
# own UI handles that) and "copy" never touches disk.
_notify_capture_result() {
    case "$option_chosen" in
        edit) return ;; # satty is still open / user may cancel -- nothing to report yet
        copy) notify_user --a "${APP_NAME}" --i "${NOTIFICATION_ICON}" --s "Screenshot copied" --m "Copied to clipboard" --t 1000 ;;
        *)    notify_user --a "${APP_NAME}" --i "${NOTIFICATION_ICON}" --s "Screenshot saved" --m "$screenshot_folder/$NAME" --t 1000 ;;
    esac
}

# take shots
takescreenshot() {
    sleep 1
    _capture "$option_type_screenshot" "$option_chosen"
    _notify_capture_result
}

takescreenshot_timer() {
    sleep 1
    timer
    sleep 1
    _capture "$option_type_screenshot" "$option_chosen"
    _notify_capture_result
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        type_screenshot_run
        copy_save_editor_run "takescreenshot"
    elif [[ "$1" == '--opt2' ]]; then
        timer_run
        type_screenshot_run
        copy_save_editor_run "takescreenshot_timer"
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$option_1")
        run_cmd --opt1
        ;;
    "$option_2")
        run_cmd --opt2
        ;;
esac
