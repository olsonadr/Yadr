local window_rules = {

    {
        match = {
            class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_001",
    },

    {
        match = {
            class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_002",
    },

    {
        match = {
            class = "^(chrome-.+-Default)$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_003",
    },

    {
        match = {
            class = "^([Cc]hromium)$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_004",
    },

    {
        match = {
            class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_005",
    },

    {
        match = {
            class = "^([Bb]rave-browser(-beta|-dev|-unstable)?)$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_006",
    },

    {
        match = {
            class = "^([Tt]horium-browser|[Cc]achy-browser)$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_007",
    },

    {
        match = {
            class = "^(zen-alpha|zen)$",
        },
        tag = "+browser",
        name = "preset_windowrules_new_window_008",
    },

    {
        match = {
            class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$",
        },
        tag = "+notif",
        name = "preset_windowrules_new_window_009",
    },

    {
        match = {
            title = "^(KooL Quick Cheat Sheet)$",
        },
        tag = "+KooL_Cheat",
        name = "preset_windowrules_new_window_010",
    },

    {
        match = {
            title = "^(KooL Hyprland Settings)$",
        },
        tag = "+KooL_Settings",
        name = "preset_windowrules_new_window_011",
    },

    {
        match = {
            class = "^(nwg-displays|nwg-look)$",
        },
        tag = "+KooL-Settings",
        name = "preset_windowrules_new_window_012",
    },

    {
        match = {
            class = "^(ghostty|wezterm|Alacritty|kitty|kitty-dropterm)$",
        },
        tag = "+terminal",
        name = "preset_windowrules_new_window_013",
    },

    {
        match = {
            class = "^([Tt]hunderbird|org.mozilla.Thunderbird)$",
        },
        tag = "+email",
        name = "preset_windowrules_new_window_014",
    },

    {
        match = {
            class = "^(eu.betterbird.Betterbird)$",
        },
        tag = "+email",
        name = "preset_windowrules_new_window_015",
    },

    {
        match = {
            class = "^(org.gnome.Evolution)$",
        },
        tag = "+email",
        name = "preset_windowrules_new_window_016",
    },

    {
        match = {
            class = "^(codium|codium-url-handler|VSCodium)$",
        },
        tag = "+projects",
        name = "preset_windowrules_new_window_017",
    },

    {
        match = {
            class = "^(VSCode|code|code-url-handler)$",
        },
        tag = "+projects",
        name = "preset_windowrules_new_window_018",
    },

    {
        match = {
            class = "^(jetbrains-.+)$",
        },
        tag = "+projects",
        name = "preset_windowrules_new_window_019",
    },

    {
        match = {
            class = "^(dev.zed.Zed|antigravity)$",
        },
        tag = "+projects",
        name = "preset_windowrules_new_window_020",
    },

    {
        match = {
            class = "^(com.obsproject.Studio)$",
        },
        tag = "+screenshare",
        name = "preset_windowrules_new_window_021",
    },

    {
        match = {
            class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
        },
        tag = "+im",
        name = "preset_windowrules_new_window_022",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        tag = "+im",
        name = "preset_windowrules_new_window_023",
    },

    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        tag = "+im",
        name = "preset_windowrules_new_window_024",
    },

    {
        match = {
            class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$",
        },
        tag = "+im",
        name = "preset_windowrules_new_window_025",
    },

    {
        match = {
            class = "^(teams-for-linux)$",
        },
        tag = "+im",
        name = "preset_windowrules_new_window_026",
    },

    {
        match = {
            class = "^(im.riot.Riot|Element)$",
        },
        tag = "+im",
        name = "preset_windowrules_new_window_027",
    },

    {
        match = {
            class = "^(gamescope)$",
        },
        tag = "+games",
        name = "preset_windowrules_new_window_028",
    },

    {
        match = {
            class = "^(steam_app_\\\\d+)$",
        },
        tag = "+games",
        name = "preset_windowrules_new_window_029",
    },

    {
        match = {
            xdg_tag = "^(proton-game)$",
        },
        tag = "+games",
        name = "preset_windowrules_new_window_030",
    },

    {
        match = {
            class = "^([Ss]team)$",
        },
        tag = "+gamestore",
        name = "preset_windowrules_new_window_031",
    },

    {
        match = {
            title = "^([Ll]utris)$",
        },
        tag = "+gamestore",
        name = "preset_windowrules_new_window_032",
    },

    {
        match = {
            class = "^(com.heroicgameslauncher.hgl)$",
        },
        tag = "+gamestore",
        name = "preset_windowrules_new_window_033",
    },

    {
        match = {
            class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$",
        },
        tag = "+file-manager",
        name = "preset_windowrules_new_window_034",
    },

    {
        match = {
            class = "^(app.drey.Warp)$",
        },
        tag = "+file-manager",
        name = "preset_windowrules_new_window_035",
    },

    {
        match = {
            class = "^([Ww]aytrogen)$",
        },
        tag = "+wallpaper",
        name = "preset_windowrules_new_window_036",
    },

    {
        match = {
            class = "^([Aa]udacious)$",
        },
        tag = "+multimedia",
        name = "preset_windowrules_new_window_037",
    },

    {
        match = {
            class = "^([Mm]pv|vlc)$",
        },
        tag = "+multimedia_video",
        name = "preset_windowrules_new_window_038",
    },

    {
        match = {
            title = "^(ROG Control)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_039",
    },

    {
        match = {
            class = "^(wihotspot(-gui)?)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_040",
    },

    {
        match = {
            class = "^([Bb]aobab|org.gnome.[Bb]aobab)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_041",
    },

    {
        match = {
            class = "^(gnome-disks|wihotspot(-gui)?)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_042",
    },

    {
        match = {
            title = "(Kvantum Manager)",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_043",
    },

    {
        match = {
            class = "^(file-roller|org.gnome.FileRoller)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_044",
    },

    {
        match = {
            class = "^(nm-applet|nm-connection-editor|blueman-manager)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_045",
    },

    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_046",
    },

    {
        match = {
            class = "^(qt5ct|qt6ct)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_047",
    },

    {
        match = {
            class = "(xdg-desktop-portal-gtk)",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_048",
    },

    {
        match = {
            class = "^(org.kde.polkit-kde-authentication-agent-1)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_049",
    },

    {
        match = {
            class = "^([Rr]ofi)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_050",
    },

    {
        match = {
            class = "^(btrfs-assistant)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_051",
    },

    {
        match = {
            class = "^(timeshift-gtk)$",
        },
        tag = "+settings",
        name = "preset_windowrules_new_window_052",
    },

    {
        match = {
            class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
        },
        tag = "+viewer",
        name = "preset_windowrules_new_window_053",
    },

    {
        match = {
            class = "^(evince)$",
        },
        tag = "+viewer",
        name = "preset_windowrules_new_window_054",
    },

    {
        match = {
            class = "^(eog|org.gnome.Loupe)$",
        },
        tag = "+viewer",
        name = "preset_windowrules_new_window_055",
    },

    {
        match = {
            tag = "multimedia",
        },
        no_blur = true,
        name = "preset_windowrules_new_window_056",
    },

    {
        match = {
            tag = "multimedia",
        },
        opacity = "1.0",
        name = "preset_windowrules_new_window_057",
    },

    {
        match = {
            class = "([Zz]oom|onedriver|onedriver-launcher)",
        },
        float = true,
        name = "preset_windowrules_new_window_058",
    },

    {
        match = {
            class = "^(mpv|com.github.rafostar.Clapper)$",
        },
        float = true,
        name = "preset_windowrules_new_window_059",
    },

    {
        match = {
            class = "^([Qq]alculate-gtk)$",
        },
        float = true,
        name = "preset_windowrules_new_window_060",
    },

    {
        match = {
            title = "^(Authentication Required)$",
        },
        float = true,
        center = true,
        name = "preset_windowrules_new_window_061",
    },

    {
        match = {
            class = "^(xfce-polkit|mate-polkit|polkit-mate-authentication-agent-1)$",
            title = "^(Authentication required|Authentication Required)$",
        },
        float = true,
        center = true,
        size = "monitor_w*0.35 monitor_h*0.35",
        name = "preset_windowrules_new_window_062",
    },

    {
        match = {
            class = "(codium|codium-url-handler|VSCodium)",
            title = "negative:(.*codium.*|.*VSCodium.*)",
        },
        float = true,
        name = "preset_windowrules_new_window_063",
    },

    {
        match = {
            class = "^(com.heroicgameslauncher.hgl)$",
            title = "negative:(Heroic Games Launcher)",
        },
        float = true,
        name = "preset_windowrules_new_window_064",
    },

    {
        match = {
            class = "^([Ss]team)$",
            title = "negative:^([Ss]team)$",
        },
        float = true,
        name = "preset_windowrules_new_window_065",
    },

    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        float = true,
        size = "monitor_w*0.7 monitor_h*0.6",
        center = true,
        name = "preset_windowrules_new_window_066",
    },

    {
        match = {
            title = "^(Save As)$",
        },
        float = true,
        size = "monitor_w*0.7 monitor_h*0.6",
        center = true,
        name = "preset_windowrules_new_window_067",
    },

    {
        match = {
            initial_title = "(Open Files)",
        },
        float = true,
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "preset_windowrules_new_window_068",
    },

    {
        match = {
            title = "^(SDDM Background)$",
        },
        float = true,
        center = true,
        size = "monitor_w*0.16 monitor_h*0.12",
        name = "preset_windowrules_new_window_069",
    },

    {
        match = {
            class = "^(yad)$",
        },
        float = true,
        center = true,
        size = "monitor_w*0.2 monitor_h*0.2",
        name = "preset_windowrules_new_window_070",
    },

    {
        match = {
            class = "^(hyprland-donate-screen)$",
        },
        float = true,
        center = true,
        name = "preset_windowrules_new_window_071",
    },

    {
        match = {
            title = "^(ROG Control)$",
        },
        center = true,
        name = "preset_windowrules_new_window_072",
    },

    {
        match = {
            title = "^(Keybindings)$",
        },
        center = true,
        name = "preset_windowrules_new_window_073",
    },

    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        center = true,
        name = "preset_windowrules_new_window_074",
    },

    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        center = true,
        name = "preset_windowrules_new_window_075",
    },

    {
        match = {
            class = "^(nm-connection-editor)$",
        },
        center = true,
        name = "preset_windowrules_new_window_076",
    },

    {
        match = {
            class = "^(nm-applet)$",
            title = "^(Wi-Fi Network Authentication Required)$",
        },
        center = true,
        name = "preset_windowrules_new_window_077",
    },

    {
        match = {
            fullscreen = true,
        },
        idle_inhibit = "fullscreen",
        name = "preset_windowrules_new_window_078",
    },

    {
        match = {
            fullscreen = true,
        },
        idle_inhibit = "fullscreen",
        name = "preset_windowrules_new_window_079",
    },

    {
        match = {
            class = ".*",
        },
        idle_inhibit = "fullscreen",
        name = "preset_windowrules_new_window_080",
    },

    {
        match = {
            title = ".*",
        },
        idle_inhibit = "fullscreen",
        name = "preset_windowrules_new_window_081",
    },

    {
        match = {
            tag = "browser",
        },
        opacity = "0.99 0.8",
        name = "preset_windowrules_new_window_082",
    },

    {
        match = {
            tag = "projects",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_new_window_083",
    },

    {
        match = {
            tag = "im",
        },
        opacity = "0.94 0.86",
        name = "preset_windowrules_new_window_084",
    },

    {
        match = {
            tag = "multimedia",
        },
        opacity = "0.94 0.86",
        name = "preset_windowrules_new_window_085",
    },

    {
        match = {
            tag = "file-manager",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_new_window_086",
    },

    {
        match = {
            tag = "terminal",
        },
        opacity = "0.9 0.7",
        name = "preset_windowrules_new_window_087",
    },

    {
        match = {
            class = "^(gedit|org.gnome.TextEditor|mousepad)$",
        },
        opacity = "0.8 0.7",
        name = "preset_windowrules_new_window_088",
    },

    {
        match = {
            class = "^(deluge)$",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_new_window_089",
    },

    {
        match = {
            class = "^(seahorse)$",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_new_window_090",
    },

    {
        match = {
            class = "^(jetbrains-.*)$",
        },
        no_initial_focus = true,
        name = "preset_windowrules_new_window_091",
    },

    {
        match = {
            title = "^(wind.*)$",
        },
        no_initial_focus = true,
        name = "preset_windowrules_new_window_092",
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
        name = "preset_windowrules_new_layer_001",
    },

    {
        match = {
            namespace = "notifications",
        },
        blur = true,
        name = "preset_windowrules_new_layer_002",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        blur = true,
        name = "preset_windowrules_new_layer_003",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        ignore_alpha = "0.5",
        name = "preset_windowrules_new_layer_004",
    },

    {
        match = {
            namespace = "wallpaper",
        },
        blur = true,
        name = "preset_windowrules_new_layer_005",
    },

    {
        match = {
            namespace = "rofi",
        },
        animation = "slide",
        name = "preset_windowrules_new_layer_006",
    },

    {
        match = {
            namespace = "notifications",
        },
        animation = "slide",
        name = "preset_windowrules_new_layer_007",
    },

}
for _, rule in ipairs(layer_rules) do
    hl.layer_rule(rule)
end
