# xCloud Dotfiles - Dotfiles for Hyprland

<p align="center">
  <img src="assets/xcloud-logo.png" alt="xCloud" width="360">
</p>

An advanced configuration of Hyprland for Arch Linux based distributions, Fedora and openSuse Tumbleweed.

Full featured desktop environment based on the dynamic tiling window manager Hyprland with adaptive material color themes based on the selected wallpaper for all components. Including a comprehensive selection of apps with the ability to customize the configuration to your personal needs.

This is a personal fork of [mylinuxforwork/dotfiles](https://github.com/mylinuxforwork/dotfiles) ("ML4W OS"), rebranded and maintained independently by [xCloud](https://xcloud.gg). See [CREDITS.md](CREDITS.md) for full upstream attribution.

<img src="assets/xcloud-tux.png" alt="Tux, the xCloud mascot" width="120" align="right">

xCloud's mascot is **Tux**, suited up and ready to hammer bugs — you'll see him show up around the project (notifications use him as their icon by default).

## Installation

There is no hosted web installer or Live ISO for this fork, but the installer app *is* forked and working: [xc0sh/xcloud-dotfiles-installer](https://github.com/xc0sh/xcloud-dotfiles-installer) is a rebrand of upstream ML4W's own `ml4w-dotfiles-installer` — a real profile-manager CLI, not a stub. It handles distro dependency installation, safe sandboxed symlinking with automatic backups, and update/restore logic.

### Recommended: via the installer

```sh
bash <(curl -s https://raw.githubusercontent.com/xc0sh/xcloud-dotfiles-installer/main/demo/setup.sh)
```

This installs the installer itself, then runs it against this repo's `hyprland-dotfiles.dotinst` manifest — dependencies, preflight/post-install scripts, and symlinking all happen automatically. See that repo's own README for `--testmode`, blacklisting files from being overwritten on update, and per-profile `post.sh` overrides.

Arch, Fedora and openSuse Tumbleweed are directly supported.

### Manual install (without the installer app)

```sh
git clone https://github.com/xc0sh/dotfiles.git
cd dotfiles
```

1. Run the preflight/post-install script for your distro from `setup/` (e.g. `setup/preflight-arch.sh` then `setup/post-arch.sh`) to install dependencies — this now includes [GNU Stow](https://www.gnu.org/software/stow/), used below. If installing manually: `sudo pacman -S stow` (Arch), `sudo dnf install stow` (Fedora), `sudo zypper install stow` (openSUSE).
2. Each app's config is its own [Stow](https://www.gnu.org/software/stow/) package under `dotfiles/` (e.g. `dotfiles/hypr/`, `dotfiles/waybar/`). Symlink the ones you want into `$HOME`:
   ```sh
   cd dotfiles
   stow -t ~ atuin bashrc zshrc btop fastfetch fish git gtk-2.0 gtk-3.0 gtk-4.0 hypr kitty \
          matugen nvim ohmyposh qt6ct quickshell rofi swaync tmux vim waybar waypaper \
          wlogout xcloud xcloud-dotfiles-settings xresources xsettingsd zellij \
          chromium-flags edge-flags
   ```
   A fresh machine will likely already have `~/.bashrc`, `~/.zshrc`, or `~/.gtkrc-2.0` (distro defaults) — Stow will refuse to overwrite them. Either move those aside first (`mv ~/.bashrc ~/.bashrc.bak`, etc.), or use `stow --adopt <package>` to pull the existing file into the repo first, then `git checkout -- .` inside `dotfiles/` to discard that adopted content and restore this repo's version.
3. Optionally run `.config/xcloud/scripts/xcloud-wallpaper-sync` (inside the `xcloud` package, so only available after stowing it) to clone the companion [xc0sh/wallpapers](https://github.com/xc0sh/wallpapers) collection into `~/Pictures/wallpaper` for use with waypaper.
4. Also install [xc0sh/xcloud-dotfiles-settings](https://github.com/xc0sh/xcloud-dotfiles-settings) (the settings app referenced by the sidebar's "Settings" button and by `matugen`'s theming pipeline): `bash <(curl -s https://raw.githubusercontent.com/xc0sh/xcloud-dotfiles-settings/main/setup.sh)`.
5. Install the modern CLI tools wired into the shell packages above: `sudo pacman -S bat fd zoxide atuin git-delta yazi tealdeer direnv zellij bash-preexec` (Arch; `extra` repo, no AUR needed). Only `atuin`, `git`, and `zellij` ship as their own Stow packages (config above) — the rest (`bat`/`fd`/`tealdeer`/`zoxide`/`yazi`/`direnv`) are alias/init-only and already wired into the `bashrc`/`zshrc`/`fish` packages. Run `tldr --update` once after installing tealdeer to fetch its page cache.
6. tmux plugins are managed by [TPM](https://github.com/tmux-plugins/tpm), which lives outside Stow's reach on purpose (its own clone target, not tracked in this repo): `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, then inside any tmux session press `prefix + I` to fetch the plugins declared in `dotfiles/tmux/.tmux.conf`. The session picker keybind (`prefix + s`) needs [`sesh`](https://github.com/joshmedeski/sesh) on `PATH` separately — AUR-only on Arch, not added to `packages-arch` per this repo's no-AUR convention for that file.

Running `setup/post-*.sh` standalone (step 1 above) works whether or not the installer app invoked it — each script self-resolves its own `repo_path` when one hasn't already been supplied by a caller.

### Manual install without Stow

If you'd rather not symlink, copy each package's payload directly instead — one extra path segment versus the pre-Stow layout:

```sh
cp -r dotfiles/hypr/.config/hypr ~/.config/hypr
cp -r dotfiles/waybar/.config/waybar ~/.config/waybar
# ...repeat per package; root dotfiles (.bashrc etc.) live directly under
# dotfiles/bashrc/, dotfiles/zshrc/, dotfiles/gtk-2.0/, dotfiles/xresources/
```

## Known Limitations

- No hosted Wiki or Live ISO — this fork covers the dotfiles payload, the installer app, and the settings app.
- `.config/xcloud/settings/statusbar` supports `waybar`/`quickshell` only (it picks which bar the reload/toggle keybinds act on). `hypr/conf/autostart.lua` starts waybar unconditionally regardless of this setting, so `statusbar.json`'s `enabled: false` (the Quickshell-native bar component's own default) is not a bug.
- `setup/preflight-opensuse.sh` sources a `setup/_prebuilt.sh` that isn't shipped anywhere in this fork or in the installer app's own payload — its origin is unclear; the sourcing is guarded and warns to stderr and continues instead of crashing. Flagged here rather than silently dropped, since it's a real pre-existing gap (restore the file vs. drop the line is a call for whoever actually needs that step).

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
