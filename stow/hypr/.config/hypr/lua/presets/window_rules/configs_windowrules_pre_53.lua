local window_rules = {

    {
        match = {
            class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_001",
    },

    {
        match = {
            class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_002",
    },

    {
        match = {
            class = "^(chrome-.+-Default)$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_003",
    },

    {
        match = {
            class = "^([Cc]hromium)$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_004",
    },

    {
        match = {
            class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_005",
    },

    {
        match = {
            class = "^(Brave-browser(-beta|-dev|-unstable)?)$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_006",
    },

    {
        match = {
            class = "^([Tt]horium-browser|[Cc]achy-browser)$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_007",
    },

    {
        match = {
            class = "^(zen-alpha|zen)$",
        },
        tag = "+browser",
        name = "preset_windowrules_pre_53_window_008",
    },

    {
        match = {
            class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$",
        },
        tag = "+notif",
        name = "preset_windowrules_pre_53_window_009",
    },

    {
        match = {
            title = "^(KooL Quick Cheat Sheet)$",
        },
        tag = "+KooL_Cheat",
        name = "preset_windowrules_pre_53_window_010",
    },

    {
        match = {
            title = "^(KooL Hyprland Settings)$",
        },
        tag = "+KooL_Settings",
        name = "preset_windowrules_pre_53_window_011",
    },

    {
        match = {
            class = "^(nwg-displays|nwg-look)$",
        },
        tag = "+KooL-Settings",
        name = "preset_windowrules_pre_53_window_012",
    },

    {
        match = {
            class = "^(Alacritty|kitty|kitty-dropterm)$",
        },
        tag = "+terminal",
        name = "preset_windowrules_pre_53_window_013",
    },

    {
        match = {
            class = "^([Tt]hunderbird|org.gnome.Evolution)$",
        },
        tag = "+email",
        name = "preset_windowrules_pre_53_window_014",
    },

    {
        match = {
            class = "^(eu.betterbird.Betterbird)$",
        },
        tag = "+email",
        name = "preset_windowrules_pre_53_window_015",
    },

    {
        match = {
            class = "^(codium|codium-url-handler|VSCodium)$",
        },
        tag = "+projects",
        name = "preset_windowrules_pre_53_window_016",
    },

    {
        match = {
            class = "^(VSCode|code|code-url-handler)$",
        },
        tag = "+projects",
        name = "preset_windowrules_pre_53_window_017",
    },

    {
        match = {
            class = "^(jetbrains-.+)$",
        },
        tag = "+projects",
        name = "preset_windowrules_pre_53_window_018",
    },

    {
        match = {
            class = "^(com.obsproject.Studio)$",
        },
        tag = "+screenshare",
        name = "preset_windowrules_pre_53_window_019",
    },

    {
        match = {
            class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
        },
        tag = "+im",
        name = "preset_windowrules_pre_53_window_020",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        tag = "+im",
        name = "preset_windowrules_pre_53_window_021",
    },

    {
        match = {
            class = "^([Ww]hatsapp-for-linux)$",
        },
        tag = "+im",
        name = "preset_windowrules_pre_53_window_022",
    },

    {
        match = {
            class = "^(ZapZap|com.rtosta.zapzap)$",
        },
        tag = "+im",
        name = "preset_windowrules_pre_53_window_023",
    },

    {
        match = {
            class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$",
        },
        tag = "+im",
        name = "preset_windowrules_pre_53_window_024",
    },

    {
        match = {
            class = "^(teams-for-linux)$",
        },
        tag = "+im",
        name = "preset_windowrules_pre_53_window_025",
    },

    {
        match = {
            class = "^(im.riot.Riot|Element)$",
        },
        tag = "+im",
        name = "preset_windowrules_pre_53_window_026",
    },

    {
        match = {
            class = "^(gamescope)$",
        },
        tag = "+games",
        name = "preset_windowrules_pre_53_window_027",
    },

    {
        match = {
            class = "^(steam_app_\\d+)$",
        },
        tag = "+games",
        name = "preset_windowrules_pre_53_window_028",
    },

    {
        match = {
            class = "^([Ss]team)$",
        },
        tag = "+gamestore",
        name = "preset_windowrules_pre_53_window_029",
    },

    {
        match = {
            title = "^([Ll]utris)$",
        },
        tag = "+gamestore",
        name = "preset_windowrules_pre_53_window_030",
    },

    {
        match = {
            class = "^(com.heroicgameslauncher.hgl)$",
        },
        tag = "+gamestore",
        name = "preset_windowrules_pre_53_window_031",
    },

    {
        match = {
            class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$",
        },
        tag = "+file-manager",
        name = "preset_windowrules_pre_53_window_032",
    },

    {
        match = {
            class = "^(app.drey.Warp)$",
        },
        tag = "+file-manager",
        name = "preset_windowrules_pre_53_window_033",
    },

    {
        match = {
            class = "^([Ww]aytrogen)$",
        },
        tag = "+wallpaper",
        name = "preset_windowrules_pre_53_window_034",
    },

    {
        match = {
            class = "^([Aa]udacious)$",
        },
        tag = "+multimedia",
        name = "preset_windowrules_pre_53_window_035",
    },

    {
        match = {
            class = "^([Mm]pv|vlc)$",
        },
        tag = "+multimedia_video",
        name = "preset_windowrules_pre_53_window_036",
    },

    {
        match = {
            title = "^(ROG Control)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_037",
    },

    {
        match = {
            class = "^(wihotspot(-gui)?)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_038",
    },

    {
        match = {
            class = "^([Bb]aobab|org.gnome.[Bb]aobab)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_039",
    },

    {
        match = {
            class = "^(gnome-disks|wihotspot(-gui)?)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_040",
    },

    {
        match = {
            title = "(Kvantum Manager)",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_041",
    },

    {
        match = {
            class = "^(file-roller|org.gnome.FileRoller)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_042",
    },

    {
        match = {
            class = "^(nm-applet|nm-connection-editor|blueman-manager)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_043",
    },

    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_044",
    },

    {
        match = {
            class = "^(qt5ct|qt6ct|[Yy]ad)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_045",
    },

    {
        match = {
            class = "(xdg-desktop-portal-gtk)",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_046",
    },

    {
        match = {
            class = "^(org.kde.polkit-kde-authentication-agent-1)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_047",
    },

    {
        match = {
            class = "^([Rr]ofi)$",
        },
        tag = "+settings",
        name = "preset_windowrules_pre_53_window_048",
    },

    {
        match = {
            class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
        },
        tag = "+viewer",
        name = "preset_windowrules_pre_53_window_049",
    },

    {
        match = {
            class = "^(evince)$",
        },
        tag = "+viewer",
        name = "preset_windowrules_pre_53_window_050",
    },

    {
        match = {
            class = "^(eog|org.gnome.Loupe)$",
        },
        tag = "+viewer",
        name = "preset_windowrules_pre_53_window_051",
    },

    {
        match = {
            tag = "multimedia_video*",
        },
        no_blur = true,
        name = "preset_windowrules_pre_53_window_052",
    },

    {
        match = {
            tag = "multimedia_video*",
        },
        opacity = "1.0",
        name = "preset_windowrules_pre_53_window_053",
    },

    {
        match = {
            tag = "KooL_Cheat*",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_054",
    },

    {
        match = {
            class = "([Tt]hunar)",
            title = "negative:(.*[Tt]hunar.*)",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_055",
    },

    {
        match = {
            title = "^(ROG Control)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_056",
    },

    {
        match = {
            tag = "KooL-Settings*",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_057",
    },

    {
        match = {
            title = "^(Keybindings)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_058",
    },

    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_059",
    },

    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_060",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_061",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        move = "monitor_w*0.72 monitor_h*0.07",
        name = "preset_windowrules_pre_53_window_062",
    },

    {
        match = {
            fullscreen = true,
        },
        idleinhibit = "fullscreen",
        name = "preset_windowrules_pre_53_window_063",
    },

    {
        match = {
            tag = "KooL_Cheat*",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_064",
    },

    {
        match = {
            tag = "wallpaper*",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_065",
    },

    {
        match = {
            tag = "settings*",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_066",
    },

    {
        match = {
            tag = "viewer*",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_067",
    },

    {
        match = {
            tag = "KooL-Settings*",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_068",
    },

    {
        match = {
            class = "([Zz]oom|onedriver|onedriver-launcher)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_069",
    },

    {
        match = {
            class = "(org.gnome.Calculator)",
            title = "(Calculator)",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_070",
    },

    {
        match = {
            class = "^(mpv|com.github.rafostar.Clapper)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_071",
    },

    {
        match = {
            class = "^([Qq]alculate-gtk)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_072",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_073",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_074",
    },

    {
        match = {
            title = "^(Authentication Required)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_075",
    },

    {
        match = {
            title = "^(Authentication Required)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_076",
    },

    {
        match = {
            class = "(codium|codium-url-handler|VSCodium)",
            title = "negative:(.*codium.*|.*VSCodium.*)",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_077",
    },

    {
        match = {
            class = "^(com.heroicgameslauncher.hgl)$",
            title = "negative:(Heroic Games Launcher)",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_078",
    },

    {
        match = {
            class = "^([Ss]team)$",
            title = "negative:^([Ss]team)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_079",
    },

    {
        match = {
            class = "([Tt]hunar)",
            title = "negative:(.*[Tt]hunar.*)",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_080",
    },

    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_081",
    },

    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "preset_windowrules_pre_53_window_082",
    },

    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_083",
    },

    {
        match = {
            title = "^(Save As)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_084",
    },

    {
        match = {
            title = "^(Save As)$",
        },
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "preset_windowrules_pre_53_window_085",
    },

    {
        match = {
            title = "^(Save As)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_086",
    },

    {
        match = {
            initialTitle = "(Open Files)",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_087",
    },

    {
        match = {
            initialTitle = "(Open Files)",
        },
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "preset_windowrules_pre_53_window_088",
    },

    {
        match = {
            title = "^(SDDM Background)$",
        },
        float = true,
        name = "preset_windowrules_pre_53_window_089",
    },

    {
        match = {
            title = "^(SDDM Background)$",
        },
        center = true,
        name = "preset_windowrules_pre_53_window_090",
    },

    {
        match = {
            title = "^(SDDM Background)$",
        },
        size = "monitor_w*0.16 monitor_h*0.12",
        name = "preset_windowrules_pre_53_window_091",
    },

    {
        match = {
            tag = "browser*",
        },
        opacity = "0.99 0.8",
        name = "preset_windowrules_pre_53_window_092",
    },

    {
        match = {
            tag = "projects*",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_pre_53_window_093",
    },

    {
        match = {
            tag = "im*",
        },
        opacity = "0.94 0.86",
        name = "preset_windowrules_pre_53_window_094",
    },

    {
        match = {
            tag = "multimedia*",
        },
        opacity = "0.94 0.86",
        name = "preset_windowrules_pre_53_window_095",
    },

    {
        match = {
            tag = "file-manager*",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_pre_53_window_096",
    },

    {
        match = {
            tag = "terminal*",
        },
        opacity = "0.9 0.7",
        name = "preset_windowrules_pre_53_window_097",
    },

    {
        match = {
            tag = "settings*",
        },
        opacity = "0.8 0.7",
        name = "preset_windowrules_pre_53_window_098",
    },

    {
        match = {
            tag = "viewer*",
        },
        opacity = "0.82 0.75",
        name = "preset_windowrules_pre_53_window_099",
    },

    {
        match = {
            tag = "wallpaper*",
        },
        opacity = "0.9 0.7",
        name = "preset_windowrules_pre_53_window_100",
    },

    {
        match = {
            class = "^(gedit|org.gnome.TextEditor|mousepad)$",
        },
        opacity = "0.8 0.7",
        name = "preset_windowrules_pre_53_window_101",
    },

    {
        match = {
            class = "^(deluge)$",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_pre_53_window_102",
    },

    {
        match = {
            class = "^(seahorse)$",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_pre_53_window_103",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        opacity = "0.95 0.75",
        name = "preset_windowrules_pre_53_window_104",
    },

    {
        match = {
            tag = "KooL_Cheat*",
        },
        size = "monitor_w*0.65 monitor_h*0.9",
        name = "preset_windowrules_pre_53_window_105",
    },

    {
        match = {
            tag = "wallpaper*",
        },
        size = "monitor_w*0.7 monitor_h*0.7",
        name = "preset_windowrules_pre_53_window_106",
    },

    {
        match = {
            tag = "settings*",
        },
        size = "monitor_w*0.7 monitor_h*0.7",
        name = "preset_windowrules_pre_53_window_107",
    },

    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "preset_windowrules_pre_53_window_108",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "preset_windowrules_pre_53_window_109",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        pin = true,
        name = "preset_windowrules_pre_53_window_110",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        keep_aspect_ratio = true,
        name = "preset_windowrules_pre_53_window_111",
    },

    {
        match = {
            tag = "games*",
        },
        no_blur = true,
        name = "preset_windowrules_pre_53_window_112",
    },

    {
        match = {
            tag = "games*",
        },
        fullscreen = true,
        name = "preset_windowrules_pre_53_window_113",
    },

    {
        match = {
            class = "^(jetbrains-*)",
        },
        no_initial_focus = true,
        name = "preset_windowrules_pre_53_window_114",
    },

    {
        match = {
            title = "^(wind.*)$",
        },
        no_initial_focus = true,
        name = "preset_windowrules_pre_53_window_115",
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
        name = "preset_windowrules_pre_53_layer_001",
    },

    {
        match = {
            namespace = "rofi",
        },
        ignore_alpha = 0,
        name = "preset_windowrules_pre_53_layer_002",
    },

    {
        match = {
            namespace = "notifications",
        },
        blur = true,
        name = "preset_windowrules_pre_53_layer_003",
    },

    {
        match = {
            namespace = "notifications",
        },
        ignore_alpha = 0,
        name = "preset_windowrules_pre_53_layer_004",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        blur = true,
        name = "preset_windowrules_pre_53_layer_005",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        ignore_alpha = 0,
        name = "preset_windowrules_pre_53_layer_006",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        ignore_alpha = "0.5",
        name = "preset_windowrules_pre_53_layer_007",
    },

}
for _, rule in ipairs(layer_rules) do
    hl.layer_rule(rule)
end
