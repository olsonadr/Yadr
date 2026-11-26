local window_rules = {

    {
        match = {
            tag = "multimedia_video*",
        },
        no_blur = true,
        name = "preset_windowrules_bak_window_001",
    },

    {
        match = {
            tag = "multimedia_video*",
        },
        opacity = "1.0",
        name = "preset_windowrules_bak_window_002",
    },

    {
        match = {
            tag = "KooL_Cheat*",
        },
        center = true,
        name = "preset_windowrules_bak_window_003",
    },

    {
        match = {
            class = "([Tt]hunar)",
            title = "negative:(.*[Tt]hunar.*)",
        },
        center = true,
        name = "preset_windowrules_bak_window_004",
    },

    {
        match = {
            title = "^(ROG Control)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_005",
    },

    {
        match = {
            tag = "KooL-Settings*",
        },
        center = true,
        name = "preset_windowrules_bak_window_006",
    },

    {
        match = {
            title = "^(Keybindings)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_007",
    },

    {
        match = {
            class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_008",
    },

    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_009",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_010",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        move = "monitor_w*0.72 monitor_h*0.07",
        name = "preset_windowrules_bak_window_011",
    },

    {
        match = {
            fullscreen = true,
        },
        idleinhibit = "fullscreen",
        name = "preset_windowrules_bak_window_012",
    },

    {
        match = {
            tag = "KooL_Cheat*",
        },
        float = true,
        name = "preset_windowrules_bak_window_013",
    },

    {
        match = {
            tag = "wallpaper*",
        },
        float = true,
        name = "preset_windowrules_bak_window_014",
    },

    {
        match = {
            tag = "settings*",
        },
        float = true,
        name = "preset_windowrules_bak_window_015",
    },

    {
        match = {
            tag = "viewer*",
        },
        float = true,
        name = "preset_windowrules_bak_window_016",
    },

    {
        match = {
            tag = "KooL-Settings*",
        },
        float = true,
        name = "preset_windowrules_bak_window_017",
    },

    {
        match = {
            class = "([Zz]oom|onedriver|onedriver-launcher)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_018",
    },

    {
        match = {
            class = "(org.gnome.Calculator)",
            title = "(Calculator)",
        },
        float = true,
        name = "preset_windowrules_bak_window_019",
    },

    {
        match = {
            class = "^(mpv|com.github.rafostar.Clapper)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_020",
    },

    {
        match = {
            class = "^([Qq]alculate-gtk)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_021",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_022",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_023",
    },

    {
        match = {
            title = "^(Authentication Required)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_024",
    },

    {
        match = {
            title = "^(Authentication Required)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_025",
    },

    {
        match = {
            class = "(codium|codium-url-handler|VSCodium)",
            title = "negative:(.*codium.*|.*VSCodium.*)",
        },
        float = true,
        name = "preset_windowrules_bak_window_026",
    },

    {
        match = {
            class = "^(com.heroicgameslauncher.hgl)$",
            title = "negative:(Heroic Games Launcher)",
        },
        float = true,
        name = "preset_windowrules_bak_window_027",
    },

    {
        match = {
            class = "^([Ss]team)$",
            title = "negative:^([Ss]team)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_028",
    },

    {
        match = {
            class = "([Tt]hunar)",
            title = "negative:(.*[Tt]hunar.*)",
        },
        float = true,
        name = "preset_windowrules_bak_window_029",
    },

    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_030",
    },

    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "preset_windowrules_bak_window_031",
    },

    {
        match = {
            title = "^(Add Folder to Workspace)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_032",
    },

    {
        match = {
            title = "^(Save As)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_033",
    },

    {
        match = {
            title = "^(Save As)$",
        },
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "preset_windowrules_bak_window_034",
    },

    {
        match = {
            title = "^(Save As)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_035",
    },

    {
        match = {
            initialTitle = "(Open Files)",
        },
        float = true,
        name = "preset_windowrules_bak_window_036",
    },

    {
        match = {
            initialTitle = "(Open Files)",
        },
        size = "monitor_w*0.7 monitor_h*0.6",
        name = "preset_windowrules_bak_window_037",
    },

    {
        match = {
            title = "^(SDDM Background)$",
        },
        float = true,
        name = "preset_windowrules_bak_window_038",
    },

    {
        match = {
            title = "^(SDDM Background)$",
        },
        center = true,
        name = "preset_windowrules_bak_window_039",
    },

    {
        match = {
            title = "^(SDDM Background)$",
        },
        size = "monitor_w*0.16 monitor_h*0.12",
        name = "preset_windowrules_bak_window_040",
    },

    {
        match = {
            tag = "browser*",
        },
        opacity = "0.99 0.8",
        name = "preset_windowrules_bak_window_041",
    },

    {
        match = {
            tag = "projects*",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_bak_window_042",
    },

    {
        match = {
            tag = "im*",
        },
        opacity = "0.94 0.86",
        name = "preset_windowrules_bak_window_043",
    },

    {
        match = {
            tag = "multimedia*",
        },
        opacity = "0.94 0.86",
        name = "preset_windowrules_bak_window_044",
    },

    {
        match = {
            tag = "file-manager*",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_bak_window_045",
    },

    {
        match = {
            tag = "terminal*",
        },
        opacity = "0.9 0.7",
        name = "preset_windowrules_bak_window_046",
    },

    {
        match = {
            tag = "settings*",
        },
        opacity = "0.8 0.7",
        name = "preset_windowrules_bak_window_047",
    },

    {
        match = {
            tag = "viewer*",
        },
        opacity = "0.82 0.75",
        name = "preset_windowrules_bak_window_048",
    },

    {
        match = {
            tag = "wallpaper*",
        },
        opacity = "0.9 0.7",
        name = "preset_windowrules_bak_window_049",
    },

    {
        match = {
            class = "^(gedit|org.gnome.TextEditor|mousepad)$",
        },
        opacity = "0.8 0.7",
        name = "preset_windowrules_bak_window_050",
    },

    {
        match = {
            class = "^(deluge)$",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_bak_window_051",
    },

    {
        match = {
            class = "^(seahorse)$",
        },
        opacity = "0.9 0.8",
        name = "preset_windowrules_bak_window_052",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        opacity = "0.95 0.75",
        name = "preset_windowrules_bak_window_053",
    },

    {
        match = {
            tag = "KooL_Cheat*",
        },
        size = "monitor_w*0.65 monitor_h*0.9",
        name = "preset_windowrules_bak_window_054",
    },

    {
        match = {
            tag = "wallpaper*",
        },
        size = "monitor_w*0.7 monitor_h*0.7",
        name = "preset_windowrules_bak_window_055",
    },

    {
        match = {
            tag = "settings*",
        },
        size = "monitor_w*0.7 monitor_h*0.7",
        name = "preset_windowrules_bak_window_056",
    },

    {
        match = {
            class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "preset_windowrules_bak_window_057",
    },

    {
        match = {
            class = "^([Ff]erdium)$",
        },
        size = "monitor_w*0.6 monitor_h*0.7",
        name = "preset_windowrules_bak_window_058",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        pin = true,
        name = "preset_windowrules_bak_window_059",
    },

    {
        match = {
            title = "^(Picture-in-Picture)$",
        },
        keep_aspect_ratio = true,
        name = "preset_windowrules_bak_window_060",
    },

    {
        match = {
            tag = "games*",
        },
        no_blur = true,
        name = "preset_windowrules_bak_window_061",
    },

    {
        match = {
            tag = "games*",
        },
        fullscreen = true,
        name = "preset_windowrules_bak_window_062",
    },

    {
        match = {
            class = "^(jetbrains-*)",
        },
        no_initial_focus = true,
        name = "preset_windowrules_bak_window_063",
    },

    {
        match = {
            title = "^(wind.*)$",
        },
        no_initial_focus = true,
        name = "preset_windowrules_bak_window_064",
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
        name = "preset_windowrules_bak_layer_001",
    },

    {
        match = {
            namespace = "rofi",
        },
        ignore_alpha = 0,
        name = "preset_windowrules_bak_layer_002",
    },

    {
        match = {
            namespace = "notifications",
        },
        blur = true,
        name = "preset_windowrules_bak_layer_003",
    },

    {
        match = {
            namespace = "notifications",
        },
        ignore_alpha = 0,
        name = "preset_windowrules_bak_layer_004",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        blur = true,
        name = "preset_windowrules_bak_layer_005",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        ignore_alpha = 0,
        name = "preset_windowrules_bak_layer_006",
    },

    {
        match = {
            namespace = "quickshell:overview",
        },
        ignore_alpha = "0.5",
        name = "preset_windowrules_bak_layer_007",
    },

}
for _, rule in ipairs(layer_rules) do
    hl.layer_rule(rule)
end
