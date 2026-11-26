local home = os.getenv("HOME")

hl.env("DOTS_VERSION", "2.3.23")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CONFIG_HOME", home .. "/.config")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")
hl.env("GDK_SCALE", "1")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("EDITOR", "nvim")

hl.monitor({
    output = "desc:Chimei Innolux Corporation 0x14C9",
    mode = "1920x1080@60.01",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "desc:Samsung Electric Company SAMSUNG 0x01000E00",
    mode = "2560x1440@60.0",
    position = "1920x0",
    scale = 1,
    mirror = "eDP-1",
    bitdepth = 10,
})

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })

hl.config({
    dwindle = {
        preserve_split = true,
        smart_resizing = true,
        use_active_for_splits = true,
        smart_split = false,
        default_split_ratio = 1.0,
        split_bias = 0,
        precise_mouse_move = false,
        special_scale_factor = 0.9,
    },
    master = {
        new_status = "slave",
        new_on_top = true,
        new_on_active = "none",
        orientation = "left",
        mfact = 0.5,
        slave_count_for_center_master = 2,
        center_master_fallback = "left",
        smart_resizing = true,
        drop_at_cursor = true,
        always_keep_position = false,
    },
    scrolling = {
        column_width = 0.8,
        fullscreen_on_one_column = true,
        direction = "right",
        follow_focus = true,
    },
    general = {
        border_size = 1,
        gaps_in = 1,
        gaps_out = 2,
        resize_on_border = true,
        layout = "dwindle",
        col = {
            active_border = "rgb(96E3F8)",
            inactive_border = "rgb(EF6CF6)",
        },
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.8,
        shadow = {
            enabled = false,
            range = 5,
            color = "rgb(96E3F8)",
            render_power = 1,
        },
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            special = true,
        },
    },
    group = {
        col = { border_active = "rgb(E2D5F9)" },
        groupbar = { col = { active = "rgb(3A3743)" } },
    },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,
        sensitivity = 0,
        numlock_by_default = true,
        left_handed = false,
        follow_mouse = 1,
        float_switch_override_focus = true,
        touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
            clickfinger_behavior = true,
            middle_button_emulation = true,
            tap_to_click = true,
            drag_lock = false,
        },
        touchdevice = { enabled = true },
        tablet = { transform = 0, left_handed = false },
    },
    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_touch = false,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.3,
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = true,
        workspace_swipe_forever = true,
        workspace_swipe_use_r = false,
        close_max_timeout = 100,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 2,
        mouse_move_enables_dpms = true,
        enable_swallow = true,
        swallow_regex = "^(kitty|xterm|gnome-terminal)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
        enable_anr_dialog = true,
        anr_missed_pings = 15,
        allow_session_lock_restore = true,
        on_focus_under_fullscreen = 1,
    },
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
    render = { direct_scanout = 2 },
    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = 2,
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = true,
        no_break_fs_vrr = false,
        min_refresh_rate = 24,
        hotspot_padding = 1,
        inactive_timeout = 0,
        default_monitor = "",
        zoom_factor = 1.0,
        zoom_rigid = false,
        zoom_detached_camera = true,
        hide_on_key_press = true,
        hide_on_touch = false,
        hide_on_tablet = false,
        use_cpu_buffer = false,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

hl.device({
    name = "asue1209:00-04f3:319f-touchpad",
    enabled = true,
})
