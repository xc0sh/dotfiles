hl.on("hyprland.start", function ()
    local HOME = os.getenv("HOME")

    -- Read wallpaper app setting
    local wallpaper_app = "quickshell"
    local f = io.open(HOME .. "/.config/xcloud/settings/wallpaper-app", "r")
    if f then
        wallpaper_app = f:read("*l"):match("^%s*(.-)%s*$")
        f:close()
    end

    -- Export variables to systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Restart portals so they catch the environment
    hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal")

    -- awww daemon
    hl.exec_cmd("awww-daemon")

    -- Load cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

    -- Start listeners
    hl.exec_cmd("~/.config/xcloud/listeners.sh --startall")

    -- Start waybar (only when it's the configured status bar engine —
    -- the Quickshell statusbar is started unconditionally by xcloud-autostart
    -- below and reads its own enabled flag, so it needs no gating here)
    local statusbar_engine = "waybar"
    local sb = io.open(HOME .. "/.config/xcloud/settings/statusbar", "r")
    if sb then
        statusbar_engine = sb:read("*l"):match("^%s*(.-)%s*$")
        sb:close()
    end
    if statusbar_engine == "waybar" then
        hl.exec_cmd(HOME .. "/.config/waybar/launch.sh")
    end

    -- Start polkit daemon
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Restore wallpaper (skip for quickshell — handled inside xcloud-autostart)
    if wallpaper_app ~= "quickshell" then
        hl.exec_cmd("~/.config/xcloud/scripts/xcloud-wallpaper-app --restore")
    end

    -- Autostart scripts
    hl.exec_cmd("~/.config/xcloud/scripts/xcloud-autostart > ~/.mydotfiles/xcloud-autostart.log 2>&1")

    -- Load GTK settings
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")

    -- Start swaync
    hl.exec_cmd("swaync")

    -- Start hypridle
    hl.exec_cmd("hypridle")

    -- Load cliphist history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
end)
