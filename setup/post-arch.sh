#!/usr/bin/env bash

# shellcheck source=setup/_common.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/_common.sh"

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

bash <(curl -s https://raw.githubusercontent.com/xc0sh/xcloud-dotfiles-settings/main/setup.sh)

# --------------------------------------------------------------
# Quickshell Overview
# --------------------------------------------------------------

bash <(curl -s https://raw.githubusercontent.com/xc0sh/xcloud-quickshell-overview/main/install.sh)

# --------------------------------------------------------------
# Pipx
# --------------------------------------------------------------

echo ":: Installing packages with pipx"
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

