local commands = {
    "$HOME/.config/hypr/initial-boot.sh",
    "$HOME/.config/hypr/scripts/WallpaperDaemon.sh",
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    '$HOME/.config/hypr/scripts/Dropterminal.sh "kitty --class kitty-dropterm" &',
    "$HOME/.config/hypr/scripts/Polkit.sh",
    "nm-applet --indicator",
    "nm-tray",
    "swaync",
    "$HOME/.config/hypr/scripts/PortalHyprlandUbuntu.sh",
    "qs -c overview",
    "hypridle",
    "$HOME/.config/hypr/scripts/Hyprsunset.sh init",
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "blueman-applet",
    "$HOME/.config/hypr/scripts/KeybindsLayoutInit.sh",
    "waybar",
    "$HOME/.config/hypr/scripts/PortalHyprland.sh",
    "hyprctl setcursor Bibata-Modern-Classic 24",
    "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'",
    "flatpak run dev.deedles.Trayscale --hide-window",
}

hl.on("hyprland.start", function()
    for _, command in ipairs(commands) do
        hl.exec_cmd(command)
    end
end)
