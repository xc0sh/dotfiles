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

1. Run the preflight/post-install script for your distro from `setup/` (e.g. `setup/preflight-arch.sh` then `setup/post-arch.sh`) to install dependencies.
2. Copy or symlink the contents of `dotfiles/.config/` into `~/.config/`, and the root dotfiles (`dotfiles/.bashrc`, `.zshrc`, `.gtkrc-2.0`, `.Xresources`) into `$HOME`.
3. Optionally run `.config/xcloud/scripts/xcloud-wallpaper-sync` to clone the companion [xc0sh/wallpapers](https://github.com/xc0sh/wallpapers) collection into `~/Pictures/wallpaper` for use with waypaper.

Arch, Fedora and openSuse Tumbleweed are directly supported by the `setup/` scripts (inherited from upstream).

## Known Limitations

- No hosted installer, Wiki, or Live ISO — this fork covers the dotfiles payload and setup scripts only.
- The GTK settings-app UI (`ml4w-dotfiles-settings` upstream) and the separate installer app (`ml4w-dotfiles-installer`) are still ML4W-branded upstream projects and have not been forked; the in-repo `.config/xcloud-dotfiles-settings/` directory is rebranded but depends on that ecosystem for a full GUI experience.
- A few scripts still reference `xc0sh/xcloud-dotfiles-settings` and `xc0sh/xcloud-quickshell-overview` for optional companion installs — these repos don't exist yet under `xc0sh`; fork them separately if you want that functionality.

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
