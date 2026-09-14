#!/usr/bin/env bash

# shellcheck source=setup/_common.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/_common.sh"

# --------------------------------------------------------------
# nwg-displays
# --------------------------------------------------------------

if rpm -q nwg-displays &>/dev/null; then
    sudo zypper rm -y nwg-displays
fi
info "Building and deploying latest nwg-displays..."
NWG_DISPLAYS_BUILD_DIR=$(mktemp -d)
git clone https://github.com/nwg-piotr/nwg-displays.git "$NWG_DISPLAYS_BUILD_DIR"
python3 -m pip install --user --break-system-packages "$NWG_DISPLAYS_BUILD_DIR"
info "nwg-displays installed to ~/.local/bin/"
rm -rf "$NWG_DISPLAYS_BUILD_DIR"

# --------------------------------------------------------------
# awww
# --------------------------------------------------------------

sudo zypper --non-interactive --gpg-auto-import-keys install awww

# --------------------------------------------------------------
# Quickshell
# --------------------------------------------------------------

# Add DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Tumbleweed/home:AvengeMedia:danklinux.repo
sudo zypper refresh
sudo zypper --non-interactive --gpg-auto-import-keys install quickshell

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# Oh My Zsh (zshrc/.config/zshrc/20-customization sources $ZSH/oh-my-zsh.sh
# and enables zsh-autosuggestions/zsh-syntax-highlighting/
# fast-syntax-highlighting -- none of these are oh-my-zsh core, so they
# need cloning into its custom plugins dir)
# --------------------------------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A _omz_plugin_repos=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
    [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
)
for _omz_plugin in "${!_omz_plugin_repos[@]}"; do
    if [ ! -d "$ZSH_CUSTOM/plugins/$_omz_plugin" ]; then
        git clone --depth 1 "${_omz_plugin_repos[$_omz_plugin]}" "$ZSH_CUSTOM/plugins/$_omz_plugin"
    fi
done
unset _omz_plugin _omz_plugin_repos

# --------------------------------------------------------------
# xCloud Settings App
# --------------------------------------------------------------

curl -sSL https://raw.githubusercontent.com/xc0sh/xcloud-dotfiles-settings/main/setup.sh | bash

# --------------------------------------------------------------
# Quickshell Overview
# --------------------------------------------------------------

curl -sSL https://raw.githubusercontent.com/xc0sh/xcloud-quickshell-overview/main/install.sh | bash

# --------------------------------------------------------------
# Cargo
# --------------------------------------------------------------

TARGET_VERSION="4.0.0"

force_install_matugen() {
    info "Running: cargo install matugen --force"
    cargo install matugen --force
}

if ! command -v matugen &> /dev/null; then
    echo "'matugen' is not currently installed."
    force_install_matugen
else
    CURRENT_VERSION=$(matugen --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    LOWEST_VERSION=$(printf "%s\n%s" "$TARGET_VERSION" "$CURRENT_VERSION" | sort -V | head -n1)
    if [ "$LOWEST_VERSION" = "$CURRENT_VERSION" ] && [ "$CURRENT_VERSION" != "$TARGET_VERSION" ]; then
        info "Current version ($CURRENT_VERSION) is lower than $TARGET_VERSION. Updating..."
        force_install_matugen
    else
        info "matugen is already up to date! (Current version: $CURRENT_VERSION)"
    fi
fi

# --------------------------------------------------------------
# JetBrains Mono Nerd Font
# --------------------------------------------------------------

sudo zypper addrepo https://download.opensuse.org/repositories/X11:fonts/openSUSE_Factory/X11:fonts.repo
sudo zypper -n install jetbrainsmono-nerd-fonts

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
pipx install pywalfox
# pipx symlinks into ~/.local/bin, which isn't guaranteed to already be on
# PATH in the shell this script is sourced from -- ensure it's there so the
# binary just installed above can actually be found on the next line.
export PATH="$HOME/.local/bin:$PATH"
pywalfox install

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

source "$repo_path"/setup/_cursors.sh

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source "$repo_path"/setup/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source "$repo_path"/setup/_icons.sh

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update
