#!/usr/bin/env bash

# Checks the CURRENT account's (whoever runs this script) install state
# against what this repo expects: stow packages, non-stow clone targets
# (TPM, oh-my-zsh custom plugins), and system packages. Run it separately
# as each account/host you care about - it never reaches across accounts.
#
# Exists because these exact gaps (matugen not stowed for an account,
# nvim/atuin never stowed, nvim's plugins never actually lazy-synced) have
# repeatedly been found by accident, one account at a time, rather than by
# a systematic check - see CHANGELOG.md/STATE.md's parity-gap history.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_ROOT=$( cd -- "$SCRIPT_DIR/.." &> /dev/null && pwd )
DOTFILES_DIR="$REPO_ROOT/dotfiles"

# shellcheck source=/dev/null
source "$REPO_ROOT/setup/_common.sh"

GAPS=0

get_distro() {
    if command -v pacman &> /dev/null; then echo "arch";
    elif command -v dnf &> /dev/null; then echo "fedora";
    elif command -v zypper &> /dev/null; then echo "opensuse";
    else echo "unknown"; fi
}
DISTRO=$(get_distro)

echo "== xcloud-dotfiles-doctor: $(whoami)@$(hostname), repo at $REPO_ROOT, distro=$DISTRO =="

# --- 1. Stow parity ---
echo
echo "-- Stow package parity --"
if ! command -v stow &> /dev/null; then
    error "stow is not installed - cannot check package parity"
    GAPS=$((GAPS + 1))
else
    for pkg_dir in "$DOTFILES_DIR"/*/; do
        pkg=$(basename "$pkg_dir")
        OUT=$(stow -n -v -t "$HOME" -d "$DOTFILES_DIR" "$pkg" 2>&1)
        if echo "$OUT" | grep -qi 'conflict\|existing target'; then
            error "$pkg: CONFLICT - a real file is blocking it (not a symlink into this repo)"
            GAPS=$((GAPS + 1))
        elif echo "$OUT" | grep -q '^LINK:'; then
            warn "$pkg: NOT stowed"
            GAPS=$((GAPS + 1))
        else
            info "$pkg: stowed"
        fi
    done
fi

# --- 2. Non-stow clone targets ---
echo
echo "-- Non-stow dependencies --"

if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    info "TPM: present"
else
    warn "TPM: missing (~/.tmux/plugins/tpm) - see README for the clone command"
    GAPS=$((GAPS + 1))
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    info "oh-my-zsh: present"
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    for plugin in zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting; do
        if [ -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
            info "  - $plugin: present"
        else
            warn "  - $plugin: missing ($ZSH_CUSTOM/plugins/$plugin)"
            GAPS=$((GAPS + 1))
        fi
    done
else
    warn "oh-my-zsh: missing (~/.oh-my-zsh)"
    GAPS=$((GAPS + 1))
fi

if [ -d "$HOME/.local/share/xcloud-dotfiles-settings" ]; then
    info "xcloud-dotfiles-settings app: installed"
else
    warn "xcloud-dotfiles-settings app: not installed (~/.local/share/xcloud-dotfiles-settings)"
    GAPS=$((GAPS + 1))
fi

# Same 3-location lookup gtk-theme-switcher.sh/xcloud-wallpaper use.
if [ -f "$HOME/.cargo/bin/matugen" ] || [ -f "$HOME/.local/bin/matugen" ] || command -v matugen &> /dev/null; then
    info "matugen: found"
else
    warn "matugen: not found (checked ~/.cargo/bin, ~/.local/bin, PATH)"
    GAPS=$((GAPS + 1))
fi

# --- 3. System packages ---
echo
echo "-- System packages (setup/dependencies/packages, packages-$DISTRO) --"

check_package_file() {
    local file="$1"
    [ -f "$file" ] || return 0
    while IFS= read -r pkg || [ -n "$pkg" ]; do
        pkg=$(echo "$pkg" | sed 's/#.*//' | xargs)
        [[ -z "$pkg" ]] && continue

        # Same check the installer's own process_package_file uses, so
        # "doctor says missing" can never disagree with "installer would
        # install it": query the package manager first, then fall back to
        # command -v for cases where the binary name differs from the
        # package name.
        local installed=false
        case "$DISTRO" in
            arch)
                pacman -Qi "$pkg" &> /dev/null && installed=true
                ;;
            fedora|opensuse)
                rpm -q "$pkg" &> /dev/null && installed=true
                ;;
        esac
        if [ "$installed" = false ] && command -v "$pkg" &> /dev/null; then
            installed=true
        fi

        if [ "$installed" = true ]; then
            info "$pkg: installed"
        else
            warn "$pkg: NOT installed"
            GAPS=$((GAPS + 1))
        fi
    done < "$file"
}

if [ "$DISTRO" = "unknown" ]; then
    warn "Could not detect distro (no pacman/dnf/zypper) - skipping package checks"
else
    check_package_file "$REPO_ROOT/setup/dependencies/packages"
    check_package_file "$REPO_ROOT/setup/dependencies/packages-$DISTRO"
fi

# --- Summary ---
echo
if [ "$GAPS" -eq 0 ]; then
    info "No gaps found for $(whoami)@$(hostname)."
else
    error "$GAPS gap(s) found for $(whoami)@$(hostname)."
fi
exit "$GAPS"
