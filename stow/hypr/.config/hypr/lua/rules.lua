local window_rules = {
    {
        match = {
            class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
        },
        tag = "+browser",
        name = "legacy-window-001",
    },
    {
        match = {
            class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
        },
        tag = "+browser",
        name = "legacy-window-002",
    },
    {
        match = {
            class = "^(chrome-.+-Default)$",
        },
        tag = "+browser",
        name = "legacy-window-003",
    },
    {
        match = {
            class = "^([Cc]hromium)$",
        },
        tag = "+browser",
        name = "legacy-window-004",
    },
    {
        match = {
            class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
        },
        tag = "+browser",
        name = "legacy-window-005",
    },
    {
        match = {
            class = "^([Bb]rave-browser(-beta|-dev|-unstable)?)$",
        },
        tag = "+browser",
        name = "legacy-window-006",
    },
    {
        match = {
            class = "^([Tt]horium-browser|[Cc]achy-browser)$",
        },
        tag = "+browser",
        name = "legacy-window-007",
    },
    {
        match = {
            class = "^(zen-alpha|zen)$",
        },
        tag = "+browser",
        name = "legacy-window-008",
    },
    {
        match = {
            class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$",
        },
        tag = "+notif",
        name = "legacy-window-009",
    },
    {
        match = {
            title = "^(KooL Quick Cheat Sheet)$",
        },
        tag = "+KooL_Cheat",
        name = "legacy-window-010",
    },
    {
        match = {
            title = "^(KooL Hyprland Settings)$",
        },
        tag = "+KooL_Settings",
        name = "legacy-window-011",
    },
    {
        match = {
            class = "^(nwg-displays|nwg-look)$",
        },
        tag = "+KooL-Settings",
        name = "legacy-window-012",
    },
    {
        match = {
            class = "^(ghostty|wezterm|Alacritty|kitty|kitty-dropterm)$",
        },
        tag = "+terminal",
        name = "legacy-window-013",
    },
    {
        match = {
            class = "^([Tt]hunderbird|org.mozilla.Thunderbird)$",
        },
        tag = "+email",
        name = "legacy-window-014",
    },
    {
        match = {
            class = "^(eu.betterbird.Betterbird)$",
        },
        tag = "+email",
        name = "legacy-window-015",
    },
    {
        match = {
            class = "^(org.gnome.Evolution)$",
        },
        tag = "+email",
        name = "legacy-window-016",
    },
    {
        match = {
            class = "^(codium|codium-url-handler|VSCodium)$",
        },
        tag = "+projects",
        name = "legacy-window-017",
    },
    {
        match = {
            class = "^(VSCode|code|code-url-handler)$",
        },
        tag = "+projects",
        name = "legacy-window-018",
    },
    {
        match = {
            class = "^(jetbrains-.+)$",
        },
        tag = "+projects",
        name = "legacy-window-019",
    },
    {
        match = {
            class = "^(dev.zed.Zed|antigravity)$",
        },
        tag = "+projects",
        name = "legacy-window-020",
    },
    {
        match = {
            class = "^(com.obsproject.Studio)$",
        },
        tag = "+screenshare",
        name = "legacy-window-021",
    },
    {
        match = {
            class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
        },
        tag = "+im",
        name = "legacy-window-022",
    },
    {
        match = {
            class = "^([Ff]erdium)$",
        },
        tag = "+im",
        name = "legacy-window-023",
    },
    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        tag = "+im",
        name = "legacy-window-024",
    },
    {
        match = {
            class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$",
        },
        tag = "+im",
        name = "legacy-window-025",
    },
    {
        match = {
            class = "^(teams-for-linux)$",
        },
        tag = "+im",
        name = "legacy-window-026",
    },
    {
        match = {
            class = "^(im.riot.Riot|Element)$",
        },
        tag = "+im",
        name = "legacy-window-027",
    },
    {
        match = {
            class = "^(gamescope)$",
        },
        tag = "+games",
        name = "legacy-window-028",
    },
    {
        match = {
            class = "^(steam_app_\\\\d+)$",
        },
        tag = "+games",
        name = "legacy-window-029",
    },
    {
        match = {
            xdg_tag = "^(proton-game)$",
        },
        tag = "+games",
        name = "legacy-window-030",
    },
    {
        match = {
            class = "^([Ss]team)$",
        },
        tag = "+gamestore",
        name = "legacy-window-031",
    },
    {
        match = {
            title = "^([Ll]utris)$",
        },
        tag = "+gamestore",
        name = "legacy-window-032",
    },
    {
        match = {
            class = "^(com.heroicgameslauncher.hgl)$",
        },
        tag = "+gamestore",
        name = "legacy-window-033",
    },
    {
        match = {
            class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$",
        },
        tag = "+file-manager",
        name = "legacy-window-034",
    },
    {
        match = {
            class = "^(app.drey.Warp)$",
        },
        tag = "+file-manager",
        name = "legacy-window-035",
    },
    {
        match = {
            class = "^([Ww]aytrogen)$",
        },
        tag = "+wallpaper",
        name = "legacy-window-036",
    },
    {
        match = {
            class = "^([Aa]udacious)$",
        },
        tag = "+multimedia",
        name = "legacy-window-037",
    },
    {
        match = {
            class = "^([Mm]pv|vlc)$",
        },
        tag = "+multimedia_video",
        name = "legacy-window-038",
    },
    {
        match = {
            title = "^(ROG Control)$",
        },
        tag = "+settings",
        name = "legacy-window-039",
    },
    {
        match = {
            class = "^(wihotspot(-gui)?)$",
        },
        tag = "+settings",
        name = "legacy-window-040",
    },
    {
        match = {
            class = "^([Bb]aobab|org.gnome.[Bb]aobab)$",
        },
        tag = "+settings",
        name = "legacy-window-041",
    },
    {
        match = {
            class = "^(gnome-disks|wihotspot(-gui)?)$",
        },
        tag = "+settings",
        name = "legacy-window-042",
    },
    {
        match = {
            title = "(Kvantum Manager)",
        },
        tag = "+settings",
        name = "legacy-window-043",
    },
    {
        match = {
            class = "^(file-roller|org.gnome.FileRoller)$",
        },
        tag = "+settings",
        name = "legacy-window-044",
    },
    {
        match = {
            class = "^(nm-applet|nm-connection-editor|blueman-manager)$",
        },
        tag = "+settings",
        name = "legacy-window-045",
    },
    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        tag = "+settings",
        name = "legacy-window-046",
    },
    {
        match = {
            class = "^(qt5ct|qt6ct)$",
        },
        tag = "+settings",
        name = "legacy-window-047",
    },
    {
        match = {
            class = "(xdg-desktop-portal-gtk)",
        },
        tag = "+settings",
        name = "legacy-window-048",
    },
    {
        match = {
            class = "^(org.kde.polkit-kde-authentication-agent-1)$",
        },
        tag = "+settings",
        name = "legacy-window-049",
    },
    {
        match = {
            class = "^([Rr]ofi)$",
        },
        tag = "+settings",
        name = "legacy-window-050",
    },
    {
        match = {
            class = "^(btrfs-assistant)$",
        },
        tag = "+settings",
        name = "legacy-window-051",
    },
    {
        match = {
            class = "^(timeshift-gtk)$",
        },
        tag = "+settings",
        name = "legacy-window-052",
    },
    {
        match = {
            class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
        },
        tag = "+viewer",
        name = "legacy-window-053",
    },
    {
        match = {
            class = "^(evince)$",
        },
        tag = "+viewer",
        name = "legacy-window-054",
    },
    {
        match = {
            class = "^(eog|org.gnome.Loupe)$",
        },
        tag = "+viewer",
        name = "legacy-window-055",
    },
    {
        match = {
            tag = "multimedia",
        },
        no_blur = true,
        name = "legacy-window-056",
    },
    {
        match = {
            tag = "multimedia",
        },
        opacity = "1.0",
        name = "legacy-window-057",
    },
    {
        match = {
            class = "([Zz]oom|onedriver|onedriver-launcher)",
        },
        float = true,
        name = "legacy-window-058",
    },
    {
        match = {
            class = "^(mpv|com.github.rafostar.Clapper)$",
        },
        float = true,
        name = "legacy-window-059",
    },
    {
        match = {
            class = "^([Qq]alculate-gtk)$",
        },
        float = true,
        name = "legacy-window-060",
    },
    {
        match = {
            title = "^(Authentication Required)$",
        },
        float = true,
        center = true,
        name = "legacy-window-061",
    },
    {
        match = {
            class = "^(xfce-polkit|mate-polkit|polkit-mate-authentication-agent-1)$",
            title = "^(Authentication required|Authentication Required)$",
        },
        float = true,
        center = true,
        size = "monitor_w*0.35 monitor_h*0.35",
        name = "legacy-window-062",
    },
    {
        match = {
            class = "(codium|codium-url-handler|VSCodium)",
            title = "negative:(.*codium.*|.*VSCodium.*)",
        },
        float = true,
        name = "legacy-window-063",
    },
    {
        match = {
            class = "^(com.heroicgameslauncher.hgl)$",
            title = "negative:(Heroic Games Launcher)",
        },
        float = true,
        name = "legacy-window-064",
    },
    {
        match = {
            class = "^([Ss]team)$",
            title = "negative:^([Ss]team)$",
        },
        float = true,
        name = "legacy-window-065",
    },
    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        float = true,
        size = "monitor_w*0.7 monitor_h*0.6",
        center = true,
        name = "legacy-window-066",
    },
    {
        match = {
            title = "^(Save As)$",
        },
        float = true,
        size = "monitor_w*0.7 monitor_h*0.6",
        center = true,
        name = "legacy-window-067",
    },
    {
        match = {
            initial_title = "(Open Files)",
        },
        float = true,
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "legacy-window-068",
    },
    {
        match = {
            title = "^(SDDM Background)$",
        },
        float = true,
        center = true,
        size = "monitor_w*0.16 monitor_h*0.12",
        name = "legacy-window-069",
    },
    {
        match = {
            class = "^(yad)$",
        },
        float = true,
        center = true,
        size = "monitor_w*0.2 monitor_h*0.2",
        name = "legacy-window-070",
    },
    {
        match = {
            class = "^(hyprland-donate-screen)$",
        },
        float = true,
        center = true,
        name = "legacy-window-071",
    },
    {
        match = {
            title = "^(ROG Control)$",
        },
        center = true,
        name = "legacy-window-072",
    },
    {
        match = {
            title = "^(Keybindings)$",
        },
        center = true,
        name = "legacy-window-073",
    },
    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        center = true,
        name = "legacy-window-074",
    },
    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        center = true,
        name = "legacy-window-075",
    },
    {
        match = {
            class = "^(nm-connection-editor)$",
        },
        center = true,
        name = "legacy-window-076",
    },
    {
        match = {
            class = "^(nm-applet)$",
            title = "^(Wi-Fi Network Authentication Required)$",
        },
        center = true,
        name = "legacy-window-077",
    },
    {
        match = {
            fullscreen = true,
        },
        idle_inhibit = "fullscreen",
        name = "legacy-window-078",
    },
    {
        match = {
            fullscreen = true,
        },
        idle_inhibit = "fullscreen",
        name = "legacy-window-079",
    },
    {
        match = {
            class = ".*",
        },
        idle_inhibit = "fullscreen",
        name = "legacy-window-080",
    },
    {
        match = {
            title = ".*",
        },
        idle_inhibit = "fullscreen",
        name = "legacy-window-081",
    },
    {
        match = {
            tag = "browser",
        },
        opacity = "0.99 0.8",
        name = "legacy-window-082",
    },
    {
        match = {
            tag = "projects",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-083",
    },
    {
        match = {
            tag = "im",
        },
        opacity = "0.94 0.86",
        name = "legacy-window-084",
    },
    {
        match = {
            tag = "multimedia",
        },
        opacity = "0.94 0.86",
        name = "legacy-window-085",
    },
    {
        match = {
            tag = "file-manager",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-086",
    },
    {
        match = {
            tag = "terminal",
        },
        opacity = "0.9 0.7",
        name = "legacy-window-087",
    },
    {
        match = {
            class = "^(gedit|org.gnome.TextEditor|mousepad)$",
        },
        opacity = "0.8 0.7",
        name = "legacy-window-088",
    },
    {
        match = {
            class = "^(deluge)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-089",
    },
    {
        match = {
            class = "^(seahorse)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-090",
    },
    {
        match = {
            class = "^(jetbrains-.*)$",
        },
        no_initial_focus = true,
        name = "legacy-window-091",
    },
    {
        match = {
            title = "^(wind.*)$",
        },
        no_initial_focus = true,
        name = "legacy-window-092",
    },
    {
        match = {
            title = "^[Pp]icture-in-[Pp]icture$",
        },
        name = "Picture-in-Picture",
        float = true,
        move = "monitor_w*0.72 monitor_h*0.07",
        opacity = "0.95 0.75",
        pin = true,
        keep_aspect_ratio = true,
        size = "monitor_w*0.3 monitor_h*0.3",
    },
    {
        match = {
            class = "^(org.cachyos.KernelManager)$",
            title = "^(CachyOS Kernel Manager)$",
            initial_class = "^(org.cachyos.KernelManager)$",
            initial_title = "^(CachyOS Kernel Manager)$",
        },
        name = "CachyOS Kernel Manager",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(mainline-gtk)$",
            title = "^(Mainline Kernels)$",
            initial_class = "^(mainline-gtk)$",
            initial_title = "^(Mainline Kernels)$",
        },
        name = "Mainline Kernels",
        float = true,
        center = true,
        size = "monitor_w*0.45 monitor_h*0.55",
    },
    {
        match = {
            class = "^(org.kde.kwalletmanager)$",
            title = "^(Wallet Manager)$",
            initial_class = "^(org.kde.kwalletmanager)$",
            initial_title = "^(Wallet Manager)$",
        },
        name = "Kwallet",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(nvidia-settings)$",
            title = "^(NVIDIA Settings)$",
            initial_class = "^(nvidia-settings)$",
            initial_title = "^(NVIDIA Settings)$",
        },
        name = "NVIDIA Settings",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(org.cachyos.cachyos-pi)$",
            title = "^(CachyOS Package Installer)$",
            initial_class = "^(org.cachyos.cachyos-pi)$",
            initial_title = "^(CachyOS Package Installer)$",
        },
        name = "CachyOS Package Installer",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(com.shellyorg.shelly)$",
            title = "^(Shelly)$",
            initial_class = "^(com.shellyorg.shelly)$",
            initial_title = "^(Shelly)$",
        },
        name = "Shelly",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(CachyOSHello)$",
            title = "^(CachyOS Hello)$",
            initial_class = "^(CachyOSHello)$",
            initial_title = "^(CachyOS Hello)$",
        },
        name = "CachyOS Hello",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(octopi-cachecleaner)$",
            title = "^(Cache Cleaner - Octopi)$",
            initial_class = "^(octopi-cachecleaner)$",
            initial_title = "^(Cache Cleaner - Octopi)$",
        },
        name = "Cache Cleaner - Octopi",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(octopi)$",
            title = "^(Octopi)$",
            initial_class = "^(octopi)$",
            initial_title = "^(Octopi)$",
        },
        name = "Octopi Package Manager",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(octopi-repoeditor)$",
            title = "^(Repository Editor - Octopi)$",
            initial_class = "^(octopi-repoeditor)$",
            initial_title = "^(Repository Editor - Octop)$",
        },
        name = "Repository Editor - Octopi",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            tag = "KooL_Cheat",
        },
        name = "KooL Cheat (tag)",
        float = true,
        center = true,
        size = "monitor_w*0.65 monitor_h*0.9",
    },
    {
        match = {
            tag = "wallpaper",
        },
        name = "Wallpaper (tag)",
        float = true,
        center = true,
        size = "monitor_w*0.7 monitor_h*0.7",
        opacity = "0.9 0.7",
    },
    {
        match = {
            tag = "settings",
        },
        name = "Settings (tag)",
        float = true,
        center = true,
        size = "monitor_w*0.7 monitor_h*0.7",
        opacity = "0.8 0.7",
    },
    {
        match = {
            tag = "viewer",
        },
        name = "Viewer (tag)",
        float = true,
        center = true,
        opacity = "0.82 0.75",
    },
    {
        match = {
            tag = "KooL-Settings",
        },
        name = "KooL Settings (tag)",
        float = true,
        center = true,
    },
    {
        match = {
            tag = "multimedia_video",
        },
        name = "Multimedia Video (tag)",
        no_blur = true,
        opacity = "1.0",
    },
    {
        match = {
            tag = "games",
        },
        name = "Games (tag)",
        no_blur = true,
        fullscreen = false,
    },
    {
        match = {
            class = "^([Ff]erdium)$",
        },
        name = "Ferdium",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.7",
    },
    {
        match = {
            class = "(org.gnome.Calculator|qalculate-gtk)",
        },
        name = "Calculators",
        float = true,
        center = true,
        size = "monitor_w*0.55 monitor_h*0.45",
    },
    {
        match = {
            class = "([Tt]hunar)",
            title = "negative:(.*[Tt]hunar.*)",
        },
        name = "Thunar Dialogs",
        float = true,
        center = true,
    },
    {
        match = {
            class = "^(Bitwarden)$",
            title = "^(Bitwarden)$",
            initial_class = "^(Bitwarden)$",
            initial_title = "^(Bitwarden)$",
        },
        name = "Bitwarden",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(hyprpwcenter)$",
            initial_class = "^(hyprpwcenter)$",
        },
        name = "hyprland audio panel",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(garuda-assistant)$",
            title = "^(Garuda Assistant)$",
            initial_class = "^(garuda-assistant)$",
            initial_title = "^(Garuda Assistant)$",
        },
        name = "Garuda Assistant",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.6",
    },
    {
        match = {
            class = "^(com.github.hyprmod)$",
            title = "^(HyprMod)$",
            initial_class = "^(com.github.hyprmod)$",
            initial_title = "^(HyprMod)$",
        },
        name = "HyprMod GUI",
        float = true,
        center = true,
        size = "monitor_w*0.7 monitor_h*0.75",
    },
    {
        match = {
            class = "^(com.github.wwmm.easyeffects)$",
            title = "^(Easy Effects)$",
            initial_class = "^(com.github.wwmm.easyeffects)$",
            initial_title = "^(Easy Effects)$",
        },
        name = "EasyEffects",
        float = true,
        center = true,
        size = "monitor_w*0.6 monitor_h*0.65",
    },
    {
        match = {
            class = "^(io.github.amit9838.mousam)$",
            title = "^(Mousam)$",
            initial_class = "^(io.github.amit9838.mousam)$",
            initial_title = "^(Mousam)$",
        },
        name = "Mousam Weather",
        float = true,
        center = true,
        size = "monitor_w*0.7 monitor_h*0.75",
    },
    {
        match = {
            tag = "browser",
        },
        opacity = "0.99 0.95",
        name = "legacy-window-120",
    },
    {
        match = {
            tag = "projects",
        },
        opacity = "0.95 0.9",
        name = "legacy-window-121",
    },
    {
        match = {
            tag = "im",
        },
        opacity = "0.94 0.86",
        name = "legacy-window-122",
    },
    {
        match = {
            tag = "multimedia",
        },
        opacity = "0.94 0.86",
        name = "legacy-window-123",
    },
    {
        match = {
            tag = "file-manager",
        },
        opacity = "0.95 0.9",
        name = "legacy-window-124",
    },
    {
        match = {
            tag = "terminal",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-125",
    },
    {
        match = {
            class = "albert",
        },
        pin = true,
        name = "legacy-window-126",
    },
    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)",
        },
        center = true,
        name = "legacy-window-127",
    },
    {
        match = {
            class = "^([Ww]hatsapp-for-linux)$",
        },
        center = true,
        name = "legacy-window-128",
    },
    {
        match = {
            class = "^([Ff]erdium)$",
        },
        center = true,
        name = "legacy-window-129",
    },
    {
        match = {
            title = "^(KooL Quick Cheat Sheet)$",
        },
        center = true,
        name = "legacy-window-130",
    },
    {
        match = {
            class = "([Tt]hunar)",
            title = "(File Operation Progress)",
        },
        center = true,
        name = "legacy-window-131",
    },
    {
        match = {
            class = "([Tt]hunar)",
            title = "(Confirm to replace files)",
        },
        center = true,
        name = "legacy-window-132",
    },
    {
        match = {
            title = "^(ROG Control)$",
        },
        center = true,
        name = "legacy-window-133",
    },
    {
        match = {
            title = "^(Keybindings)$",
        },
        center = true,
        name = "legacy-window-134",
    },
    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        move = "monitor_w*0.72 monitor_h*0.07",
        name = "legacy-window-135",
    },
    {
        match = {
            title = "^(KooL Quick Cheat Sheet)$",
        },
        float = true,
        name = "legacy-window-136",
    },
    {
        match = {
            class = "^(org.kde.polkit-kde-authentication-agent-1)$",
        },
        float = true,
        name = "legacy-window-137",
    },
    {
        match = {
            class = "([Zz]oom|onedriver|onedriver-launcher)$",
        },
        float = true,
        name = "legacy-window-138",
    },
    {
        match = {
            class = "([Tt]hunar)",
            title = "(File Operation Progress)",
        },
        float = true,
        name = "legacy-window-139",
    },
    {
        match = {
            class = "([Tt]hunar)",
            title = "(Confirm to replace files)",
        },
        float = true,
        name = "legacy-window-140",
    },
    {
        match = {
            class = "(xdg-desktop-portal-gtk)",
        },
        float = true,
        name = "legacy-window-141",
    },
    {
        match = {
            class = "(org.gnome.Calculator)",
            title = "(Calculator)",
        },
        float = true,
        name = "legacy-window-142",
    },
    {
        match = {
            class = "(codium|codium-url-handler|VSCodium|code-oss)",
            title = "(Add Folder to Workspace)",
        },
        float = true,
        name = "legacy-window-143",
    },
    {
        match = {
            class = "(electron)",
            title = "(Add Folder to Workspace)",
        },
        float = true,
        name = "legacy-window-144",
    },
    {
        match = {
            class = "^([Rr]ofi)$",
        },
        float = true,
        name = "legacy-window-145",
    },
    {
        match = {
            class = "^(eog|org.gnome.Loupe)$",
        },
        float = true,
        name = "legacy-window-146",
    },
    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        float = true,
        name = "legacy-window-147",
    },
    {
        match = {
            class = "^(nwg-look|qt5ct|qt6ct)$",
        },
        float = true,
        name = "legacy-window-148",
    },
    {
        match = {
            class = "^(mpv|com.github.rafostar.Clapper)$",
        },
        float = true,
        name = "legacy-window-149",
    },
    {
        match = {
            class = "^(nm-applet|nm-connection-editor|blueman-manager)$",
        },
        float = true,
        name = "legacy-window-150",
    },
    {
        match = {
            class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
        },
        float = true,
        name = "legacy-window-151",
    },
    {
        match = {
            class = "^([Yy]ad)$",
        },
        float = true,
        name = "legacy-window-152",
    },
    {
        match = {
            class = "^(wihotspot(-gui)?)$",
        },
        float = true,
        name = "legacy-window-153",
    },
    {
        match = {
            class = "^(evince)$",
        },
        float = true,
        name = "legacy-window-154",
    },
    {
        match = {
            class = "^(file-roller|org.gnome.FileRoller)$",
        },
        float = true,
        name = "legacy-window-155",
    },
    {
        match = {
            class = "^([Bb]aobab|org.gnome.[Bb]aobab)$",
        },
        float = true,
        name = "legacy-window-156",
    },
    {
        match = {
            title = "(Kvantum Manager)",
        },
        float = true,
        name = "legacy-window-157",
    },
    {
        match = {
            class = "^([Ss]team)$",
            title = "^([^Ss].*|[Ss][^t].*|[Ss]t[^e].*|[Ss]te[^a].*|[Ss]tea[^m].*|[Ss]team [Ss]ettings)$",
        },
        float = true,
        name = "legacy-window-158",
    },
    {
        match = {
            class = "^([Qq]alculate-gtk)$",
        },
        float = true,
        name = "legacy-window-159",
    },
    {
        match = {
            class = "^([Ff]erdium)$",
        },
        float = true,
        name = "legacy-window-160",
    },
    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        float = true,
        name = "legacy-window-161",
    },
    {
        match = {
            title = "^(ROG Control)$",
        },
        float = true,
        name = "legacy-window-162",
    },
    {
        match = {
            title = "^(hyprgui)$",
        },
        float = true,
        name = "legacy-window-163",
    },
    {
        match = {
            class = "^([Rr]ofi)$",
        },
        opacity = "0.9 0.6",
        name = "legacy-window-164",
    },
    {
        match = {
            class = "^(Brave-browser(-beta|-dev)?)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-165",
    },
    {
        match = {
            class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-166",
    },
    {
        match = {
            class = "^(zen-alpha)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-167",
    },
    {
        match = {
            class = "^([Tt]horium-browser|[Cc]achy-browser)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-168",
    },
    {
        match = {
            class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-169",
    },
    {
        match = {
            class = "^(google-chrome(-beta|-dev|-unstable)?)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-170",
    },
    {
        match = {
            class = "^(chrome-.+-Default)$",
        },
        opacity = "0.94 0.86",
        name = "legacy-window-171",
    },
    {
        match = {
            class = "^([Tt]hunar|org.gnome.Nautilus)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-172",
    },
    {
        match = {
            class = "^(pcmanfm-qt)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-173",
    },
    {
        match = {
            class = "^(gedit|org.gnome.TextEditor|mousepad)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-174",
    },
    {
        match = {
            class = "^(deluge)$",
        },
        opacity = "0.99 0.97",
        name = "legacy-window-175",
    },
    {
        match = {
            class = "^(Alacritty|kitty|kitty-dropterm)$",
        },
        opacity = "0.95 0.9",
        name = "legacy-window-176",
    },
    {
        match = {
            class = "^(nwg-look|qt5ct|qt6ct|[Yy]ad)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-177",
    },
    {
        match = {
            title = "(Kvantum Manager)",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-178",
    },
    {
        match = {
            class = "^(com.obsproject.Studio)$",
        },
        opacity = "0.9 0.7",
        name = "legacy-window-179",
    },
    {
        match = {
            class = "^([Aa]udacious)$",
        },
        opacity = "0.9 0.7",
        name = "legacy-window-180",
    },
    {
        match = {
            class = "^(jetbrains-.+)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-181",
    },
    {
        match = {
            class = "^([Dd]iscord|[Vv]esktop)$",
        },
        opacity = "0.94 0.86",
        name = "legacy-window-182",
    },
    {
        match = {
            class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-183",
    },
    {
        match = {
            class = "^(im.riot.Riot)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-184",
    },
    {
        match = {
            class = "^(gnome-disks|evince|wihotspot(-gui)?|org.gnome.baobab)$",
        },
        opacity = "0.94 0.86",
        name = "legacy-window-185",
    },
    {
        match = {
            class = "^(file-roller|org.gnome.FileRoller)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-186",
    },
    {
        match = {
            class = "^(app.drey.Warp)$",
        },
        opacity = "0.8 0.7",
        name = "legacy-window-187",
    },
    {
        match = {
            class = "^(seahorse)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-188",
    },
    {
        match = {
            class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
        },
        opacity = "0.82 0.75",
        name = "legacy-window-189",
    },
    {
        match = {
            class = "^(xdg-desktop-portal-gtk)$",
        },
        opacity = "0.9 0.8",
        name = "legacy-window-190",
    },
    {
        match = {
            class = "^([Ww]hatsapp-for-linux)$",
        },
        opacity = "0.9 0.7",
        name = "legacy-window-191",
    },
    {
        match = {
            class = "^([Ff]erdium)$",
        },
        opacity = "0.9 0.7",
        name = "legacy-window-192",
    },
    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        opacity = "0.95 0.75",
        name = "legacy-window-193",
    },
    {
        match = {
            title = "^(KooL Quick Cheat Sheet)$",
        },
        size = "monitor_w*0.65 monitor_h*0.9",
        name = "legacy-window-194",
    },
    {
        match = {
            class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
        },
        size = "monitor_w*0.7 monitor_h*0.7",
        name = "legacy-window-195",
    },
    {
        match = {
            class = "^(xdg-desktop-portal-gtk)$",
        },
        size = "monitor_w*0.7 monitor_h*0.7",
        name = "legacy-window-196",
    },
    {
        match = {
            title = "(Kvantum Manager)",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "legacy-window-197",
    },
    {
        match = {
            class = "^(qt6ct)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "legacy-window-198",
    },
    {
        match = {
            class = "^(evince|wihotspot(-gui)?)$",
        },
        size = "monitor_w*0.7 monitor_h*0.7",
        name = "legacy-window-199",
    },
    {
        match = {
            class = "^(file-roller|org.gnome.FileRoller)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "legacy-window-200",
    },
    {
        match = {
            class = "^([Ww]hatsapp-for-linux)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "legacy-window-201",
    },
    {
        match = {
            class = "^([Ff]erdium)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "legacy-window-202",
    },
    {
        match = {
            title = "^(ROG Control)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "legacy-window-203",
    },
    {
        match = {
            title = "^(hyprgui)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "legacy-window-204",
    },
    {
        match = {
            title = "^(SDDM Background)$",
        },
        float = true,
        name = "legacy-window-205",
    },
    {
        match = {
            title = "^(SDDM Background)$",
        },
        center = true,
        name = "legacy-window-206",
    },
    {
        match = {
            title = "^(SDDM Background)$",
        },
        size = "monitor_w*0.16 monitor_h*0.12",
        name = "legacy-window-207",
    },
    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        pin = true,
        name = "legacy-window-208",
    },
    {
        match = {
            class = "^(jetbrains-studio)$",
        },
        immediate = true,
        name = "legacy-window-209",
    },
    {
        match = {
            class = "^(jetbrains-studio)$",
        },
        opaque = true,
        name = "legacy-window-210",
    },
}

for _, rule in ipairs(window_rules) do
    hl.window_rule(rule)
end

local layer_rules = {
    {
        match = {
            namespace = "rofi",
        },
        blur = true,
        name = "legacy-layer-001",
    },
    {
        match = {
            namespace = "notifications",
        },
        blur = true,
        name = "legacy-layer-002",
    },
    {
        match = {
            namespace = "quickshell:overview",
        },
        blur = true,
        name = "legacy-layer-003",
    },
    {
        match = {
            namespace = "quickshell:overview",
        },
        ignore_alpha = "0.5",
        name = "legacy-layer-004",
    },
    {
        match = {
            namespace = "wallpaper",
        },
        blur = true,
        name = "legacy-layer-005",
    },
    {
        match = {
            namespace = "rofi",
        },
        animation = "slide",
        name = "legacy-layer-006",
    },
    {
        match = {
            namespace = "notifications",
        },
        animation = "slide",
        name = "legacy-layer-007",
    },
    {
        match = {
            namespace = "rofi",
        },
        blur = true,
        name = "legacy-layer-008",
    },
}

for _, rule in ipairs(layer_rules) do
    hl.layer_rule(rule)
end
