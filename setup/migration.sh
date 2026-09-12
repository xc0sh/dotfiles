#!/usr/bin/env bash

# Move nvim folder to .config
NVIM_DIR="$HOME/.config/nvim"
if [ -L $NVIM_DIR ]; then
    current_link_target=$(realpath -m "$NVIM_DIR")
    if [[ "$current_link_target" == *".mydotfiles"* ]]; then
        rm $NVIM_DIR
        echo "Symlink $NVIM_DIR removed"
        if [ -d $current_link_target ]; then
            cp -rf $current_link_target ~/.config
            if [ -d $NVIM_DIR ]; then
                rm -rf $current_link_target
            fi
            echo "$current_link_target moved to ~./config"
        fi
    fi
fi

# Remove legacy xCloud Apps
FLATPAK_ID="com.xcloud.welcome"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi
FLATPAK_ID="com.xcloud.settings"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi
FLATPAK_ID="com.xcloud.sidebar"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi
FLATPAK_ID="gg.xcloud.dotfilesinstaller"
if flatpak info "$FLATPAK_ID" > /dev/null 2>&1; then
    flatpak remove -y $FLATPAK_ID
fi

# Remove matugen from .local/bin
if [ -f $HOME/.local/bin/matugen ]; then
    rm "$HOME/.local/bin/matugen"
    info "matugen removed from ~/.local/bin"
fi

# Remove default52.conf windowrule
if [ -f $HOME/.config/hypr/conf/windowrules/default52.conf ]; then
    rm "$HOME/.config/hypr/conf/windowrules/default52.conf"
    info "default52.conf windowrule removed."
fi

if [ -f $HOME/.config/xcloud/settings/wallpaper-effect.sh ]; then
    mv $HOME/.config/xcloud/settings/wallpaper-effect.sh $HOME/.config/xcloud/settings/wallpaper-effect
fi

if [ -f $HOME/.config/xcloud/settings/wallpaper-automation.sh ]; then
    mv $HOME/.config/xcloud/settings/wallpaper-automation.sh $HOME/.config/xcloud/settings/wallpaper-automation
fi