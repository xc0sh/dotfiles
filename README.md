# xCloud Dotfiles - Dotfiles for Hyprland

An advanced configuration of Hyprland for Arch Linux based distributions, Fedora and openSuse Tumbleweed.

Full featured desktop environment based on the dynamic tiling window manager Hyprland with adaptive material color themes based on the selected wallpaper for all components. Including a comprehensive selection of apps with the ability to customize the configuration to your personal needs.

This is a personal fork of [mylinuxforwork/dotfiles](https://github.com/mylinuxforwork/dotfiles) ("ML4W OS"), rebranded and maintained independently by [xCloud](https://xcloud.gg). See [CREDITS.md](CREDITS.md) for full upstream attribution.

## Installation

There is no hosted web installer or Live ISO for this fork (unlike upstream ML4W OS, which relies on separate companion apps — `ml4w-dotfiles-installer` and `ml4w-dotfiles-settings` — that have not been forked here; see **Known Limitations** below).

To install manually:

```sh
git clone https://github.com/xc0sh/dotfiles.git
cd dotfiles
```

1. Run the preflight/post-install script for your distro from `setup/` (e.g. `setup/preflight-arch.sh` then `setup/post-arch.sh`) to install dependencies — this now includes [GNU Stow](https://www.gnu.org/software/stow/), used below. If installing manually: `sudo pacman -S stow` (Arch), `sudo dnf install stow` (Fedora), `sudo zypper install stow` (openSUSE).
2. Each app's config is its own [Stow](https://www.gnu.org/software/stow/) package under `dotfiles/` (e.g. `dotfiles/hypr/`, `dotfiles/waybar/`). Symlink the ones you want into `$HOME`:
   ```sh
   cd dotfiles
   stow -t ~ bashrc zshrc btop fastfetch fish gtk-2.0 gtk-3.0 gtk-4.0 hypr kitty \
          matugen ohmyposh qt6ct quickshell rofi swaync vim waybar waypaper \
          wlogout xcloud xcloud-dotfiles-settings xresources xsettingsd \
          chromium-flags edge-flags
   ```
   A fresh machine will likely already have `~/.bashrc`, `~/.zshrc`, or `~/.gtkrc-2.0` (distro defaults) — Stow will refuse to overwrite them. Either move those aside first (`mv ~/.bashrc ~/.bashrc.bak`, etc.), or use `stow --adopt <package>` to pull the existing file into the repo first, then `git checkout -- .` inside `dotfiles/` to discard that adopted content and restore this repo's version.
3. Optionally run `.config/xcloud/scripts/xcloud-wallpaper-sync` (inside the `xcloud` package, so only available after stowing it) to clone the companion [xc0sh/wallpapers](https://github.com/xc0sh/wallpapers) collection into `~/Pictures/wallpaper` for use with waypaper.

Arch, Fedora and openSuse Tumbleweed are directly supported by the `setup/` scripts (inherited from upstream).

### Manual install without Stow

If you'd rather not symlink, copy each package's payload directly instead — one extra path segment versus the pre-Stow layout:

```sh
cp -r dotfiles/hypr/.config/hypr ~/.config/hypr
cp -r dotfiles/waybar/.config/waybar ~/.config/waybar
# ...repeat per package; root dotfiles (.bashrc etc.) live directly under
# dotfiles/bashrc/, dotfiles/zshrc/, dotfiles/gtk-2.0/, dotfiles/xresources/
```

## Known Limitations

- No hosted installer, Wiki, or Live ISO — this fork covers the dotfiles payload and setup scripts only.
- The GTK settings-app UI (`ml4w-dotfiles-settings` upstream) and the separate installer app (`ml4w-dotfiles-installer`) are still ML4W-branded upstream projects and have not been forked; the in-repo `.config/xcloud-dotfiles-settings/` directory is rebranded but depends on that ecosystem for a full GUI experience.
- A few scripts still reference `xc0sh/xcloud-dotfiles-settings` and `xc0sh/xcloud-quickshell-overview` for optional companion installs — these repos don't exist yet under `xc0sh`; fork them separately if you want that functionality.
- `.config/xcloud/settings/walker-theme` is written by all 5 theme scripts but read by nothing — inert until `.config/xcloud/settings/launcher` is switched from `rofi` to `walker`.
- `.config/xcloud/settings/statusbar` supports `waybar`/`quickshell` only (it picks which bar the reload/toggle keybinds act on). `hypr/conf/autostart.lua` starts waybar unconditionally regardless of this setting, so `statusbar.json`'s `enabled: false` (the Quickshell-native bar component's own default) is not a bug.
- `setup/preflight-opensuse.sh` sources a `setup/_prebuilt.sh` that does not exist in this repo — a pre-existing issue inherited as-is, not yet fixed.

## Credits

See [CREDITS.md](CREDITS.md) for upstream attribution to Stephan Raabe and the ML4W project, and per-file authorship notices preserved throughout the config (e.g. rofi/waybar/wlogout themes).

## Inspirations

The following projects have inspired me:

- https://github.com/JaKooLit/Hyprland-Dots
- https://github.com/prasanthrangan/hyprdots
- https://github.com/sudo-harun/dotfiles
- https://github.com/dianaw353/hyprland-configuration-rootfs
- https://www.youtube.com/@saneAspect

and many more...
