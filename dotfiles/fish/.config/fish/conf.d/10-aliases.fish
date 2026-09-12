# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

# -----------------------------------------------------
# General
# -----------------------------------------------------
alias ..='cd ..'
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='~/.config/xcloud/scripts/xcloud-power -p'
alias v='$EDITOR'
alias vim='$EDITOR'
alias wifi='nmtui'
alias arch-cleanup='~/.config/xcloud/scripts/arch/cleanup.sh'
alias apps='~/.config/xcloud/bin/xcloud-apps'
alias screenshot='~/.config/xcloud/bin/xcloud-screenshot'
alias updates='~/.config/xcloud/scripts/xcloud-install-system-updates'
alias filemanager='~/.config/xcloud/settings/filemanager'
alias autostart='~/.config/xcloud/scripts/xcloud-autostart'
alias lock='hyprlock'
alias clock='tty-clock'
alias system='~/.config/xcloud/settings/systemmonitor'
alias quick='~/.config/xcloud/bin/xcloud-quicklinks'
alias wallpaper='~/.config/xcloud/bin/xcloud-wallpaper'
alias settings='xcloud-dotfiles-settings gg.xcloud.dotfiles'

# -----------------------------------------------------
# xCloud Apps
# -----------------------------------------------------
alias xcloud='qs ipc call welcome toggle'
alias xcloud-settings='qs -p ~/.local/share/xcloud-dotfiles-settings/quickshell ipc call settings toggle'
alias xcloud-calendar='qs ipc call calendar toggle'
alias xcloud-hyprland='flatpak run com.xcloud.hyprlandsettings'
alias xcloud-sidebar='qs ipc call sidebar toggle'

# -----------------------------------------------------
# Git
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gfo="git fetch origin"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

# -----------------------------------------------------
# Scripts
# -----------------------------------------------------
alias ascii='~/.config/xcloud/scripts/xcloud-ascii-header'

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
