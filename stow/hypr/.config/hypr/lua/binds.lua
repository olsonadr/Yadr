local home = os.getenv("HOME")
local variables = {
    HOME = home,
    mainMod = "SUPER",
    scriptsDir = home .. "/.config/hypr/scripts",
    UserScripts = home .. "/.config/hypr/UserScripts",
    UserConfigs = home .. "/.config/hypr/UserConfigs",
    term = home .. "/.local/bin/kitty",
    files = "nautilus",
}

local function expand(command)
    return (command:gsub("%$([%a_][%w_]*)", function(name)
        return variables[name] or "$" .. name
    end))
end

local function make_dispatcher(action, argument)
    local directions = { l = "left", r = "right", u = "up", d = "down" }
    if action == "exec" then
        local dropdown_prefix = "[float; move 15% 5%; size 70% 60%] "
        local command = argument
        if command:sub(1, #dropdown_prefix) == dropdown_prefix then
            command = command:sub(#dropdown_prefix + 1)
            return hl.dsp.exec_cmd(expand(command), {
                float = true,
                move = "monitor_w*0.15 monitor_h*0.05",
                size = "monitor_w*0.7 monitor_h*0.6",
            })
        end
        command = expand(command)
        command = command:gsub("misc:cursor_zoom_factor", "cursor:zoom_factor")
        return hl.dsp.exec_cmd(command)
    elseif action == "exit" then
        return hl.dsp.exit()
    elseif action == "killactive" then
        return hl.dsp.window.close()
    elseif action == "layoutmsg" then
        return hl.dsp.layout(argument)
    elseif action == "pseudo" then
        return hl.dsp.window.pseudo()
    elseif action == "togglegroup" then
        return hl.dsp.group.toggle()
    elseif action == "changegroupactive" then
        return hl.dsp.group.next()
    elseif action == "cyclenext" then
        return hl.dsp.window.cycle_next({ next = argument ~= "prev" })
    elseif action == "bringactivetotop" then
        return hl.dsp.window.bring_to_top()
    elseif action == "movefocus" then
        return hl.dsp.focus({ direction = directions[argument] or argument })
    elseif action == "workspace" then
        return hl.dsp.focus({ workspace = argument })
    elseif action == "movetoworkspace" then
        return hl.dsp.window.move({ workspace = argument, follow = true })
    elseif action == "movetoworkspacesilent" then
        return hl.dsp.window.move({ workspace = argument, follow = false })
    elseif action == "movewindow" then
        if argument == "" then
            return hl.dsp.window.drag()
        end
        return hl.dsp.window.move({ direction = directions[argument] or argument })
    elseif action == "swapwindow" then
        return hl.dsp.window.swap({ direction = directions[argument] or argument })
    elseif action == "resizeactive" then
        local x, y = argument:match("^%s*(-?%d+)%s+(-?%d+)%s*$")
        return hl.dsp.window.resize({ x = tonumber(x), y = tonumber(y), relative = true })
    elseif action == "resizewindow" then
        return hl.dsp.window.resize()
    elseif action == "fullscreen" then
        return hl.dsp.window.fullscreen({
            mode = argument == "1" and "maximized" or "fullscreen",
            action = "toggle",
        })
    elseif action == "togglefloating" then
        return hl.dsp.window.float({ action = "toggle" })
    elseif action == "togglespecialworkspace" then
        if argument == "" then
            return hl.dsp.workspace.toggle_special()
        end
        return hl.dsp.workspace.toggle_special(argument)
    end
    error("Unsupported legacy dispatcher in Lua keybind migration: " .. action)
end

local function bind(key, action, argument, options)
    hl.bind(key, make_dispatcher(action, argument), options)
end

bind("CTRL + ALT + Delete", "exec", "hyprctl dispatch exit 0", nil)
bind("SUPER + Q", "killactive", "", nil)
bind("SUPER + SHIFT + Q", "exec", "$scriptsDir/KillActiveProcess.sh", nil)
bind("CTRL + ALT + L", "exec", "$scriptsDir/LockScreen.sh", nil)
bind("CTRL + ALT + P", "exec", "$scriptsDir/Wlogout.sh", nil)
bind("SUPER + SHIFT + N", "exec", "swaync-client -t -sw", nil)
bind("SUPER + SHIFT + E", "exec", "$scriptsDir/Kool_Quick_Settings.sh", nil)
bind("SUPER + CTRL + D", "layoutmsg", "removemaster", nil)
bind("SUPER + I", "layoutmsg", "addmaster", nil)
bind("SUPER + J", "layoutmsg", "cyclenext", nil)
bind("SUPER + K", "layoutmsg", "cycleprev", nil)
bind("SUPER + CTRL + Return", "layoutmsg", "swapwithmaster", nil)
bind("SUPER + P", "pseudo", "", nil)
bind("SUPER + M", "exec", "hyprctl dispatch splitratio 0.3", nil)
bind("SUPER + G", "togglegroup", "", nil)
bind("SUPER + CTRL + tab", "changegroupactive", "", nil)
bind("ALT + tab", "cyclenext", "", nil)
bind("ALT + tab", "bringactivetotop", "", nil)
bind("xf86audioraisevolume", "exec", "$scriptsDir/Volume.sh --inc", { locked = true, repeating = true })
bind("xf86audiolowervolume", "exec", "$scriptsDir/Volume.sh --dec", { locked = true, repeating = true })
bind("xf86AudioMicMute", "exec", "$scriptsDir/Volume.sh --toggle-mic", { locked = true })
bind("xf86audiomute", "exec", "$scriptsDir/Volume.sh --toggle", { locked = true })
bind("xf86Sleep", "exec", "systemctl suspend", { locked = true })
bind("xf86Rfkill", "exec", "$scriptsDir/AirplaneMode.sh", { locked = true })
bind("xf86AudioPause", "exec", "$scriptsDir/MediaCtrl.sh --pause", { locked = true })
bind("xf86AudioPlay", "exec", "$scriptsDir/MediaCtrl.sh --pause", { locked = true })
bind("xf86AudioNext", "exec", "$scriptsDir/MediaCtrl.sh --nxt", { locked = true })
bind("xf86AudioPrev", "exec", "$scriptsDir/MediaCtrl.sh --prv", { locked = true })
bind("xf86audiostop", "exec", "$scriptsDir/MediaCtrl.sh --stop", { locked = true })
bind("SUPER + Print", "exec", "$scriptsDir/ScreenShot.sh --now", nil)
bind("SUPER + SHIFT + Print", "exec", "$scriptsDir/ScreenShot.sh --area", nil)
bind("SUPER + CTRL + Print", "exec", "$scriptsDir/ScreenShot.sh --in5", nil)
bind("SUPER + CTRL + SHIFT + Print", "exec", "$scriptsDir/ScreenShot.sh --in10", nil)
bind("ALT + Print", "exec", "$scriptsDir/ScreenShot.sh --active", nil)
bind("SUPER + SHIFT + S", "exec", "$scriptsDir/ScreenShot.sh --swappy", nil)
bind("SUPER + SHIFT + left", "resizeactive", "-50 0", { repeating = true })
bind("SUPER + SHIFT + right", "resizeactive", "50 0", { repeating = true })
bind("SUPER + SHIFT + up", "resizeactive", "0 -50", { repeating = true })
bind("SUPER + SHIFT + down", "resizeactive", "0 50", { repeating = true })
bind("SUPER + CTRL + left", "movewindow", "l", nil)
bind("SUPER + CTRL + right", "movewindow", "r", nil)
bind("SUPER + CTRL + up", "movewindow", "u", nil)
bind("SUPER + CTRL + down", "movewindow", "d", nil)
bind("SUPER + ALT + left", "swapwindow", "l", nil)
bind("SUPER + ALT + right", "swapwindow", "r", nil)
bind("SUPER + ALT + up", "swapwindow", "u", nil)
bind("SUPER + ALT + down", "swapwindow", "d", nil)
bind("SUPER + left", "movefocus", "l", nil)
bind("SUPER + right", "movefocus", "r", nil)
bind("SUPER + up", "movefocus", "u", nil)
bind("SUPER + down", "movefocus", "d", nil)
bind("SUPER + tab", "workspace", "m+1", nil)
bind("SUPER + SHIFT + tab", "workspace", "m-1", nil)
bind("SUPER + SHIFT + U", "movetoworkspace", "special", nil)
bind("SUPER + U", "togglespecialworkspace", "", nil)
bind("SUPER + code:10", "workspace", "1", nil)
bind("SUPER + code:11", "workspace", "2", nil)
bind("SUPER + code:12", "workspace", "3", nil)
bind("SUPER + code:13", "workspace", "4", nil)
bind("SUPER + code:14", "workspace", "5", nil)
bind("SUPER + code:15", "workspace", "6", nil)
bind("SUPER + code:16", "workspace", "7", nil)
bind("SUPER + code:17", "workspace", "8", nil)
bind("SUPER + code:18", "workspace", "9", nil)
bind("SUPER + code:19", "workspace", "10", nil)
bind("SUPER + SHIFT + code:10", "movetoworkspace", "1", nil)
bind("SUPER + SHIFT + code:11", "movetoworkspace", "2", nil)
bind("SUPER + SHIFT + code:12", "movetoworkspace", "3", nil)
bind("SUPER + SHIFT + code:13", "movetoworkspace", "4", nil)
bind("SUPER + SHIFT + code:14", "movetoworkspace", "5", nil)
bind("SUPER + SHIFT + code:15", "movetoworkspace", "6", nil)
bind("SUPER + SHIFT + code:16", "movetoworkspace", "7", nil)
bind("SUPER + SHIFT + code:17", "movetoworkspace", "8", nil)
bind("SUPER + SHIFT + code:18", "movetoworkspace", "9", nil)
bind("SUPER + SHIFT + code:19", "movetoworkspace", "10", nil)
bind("SUPER + SHIFT + bracketleft", "movetoworkspace", "-1", nil)
bind("SUPER + SHIFT + bracketright", "movetoworkspace", "+1", nil)
bind("SUPER + CTRL + code:10", "movetoworkspacesilent", "1", nil)
bind("SUPER + CTRL + code:11", "movetoworkspacesilent", "2", nil)
bind("SUPER + CTRL + code:12", "movetoworkspacesilent", "3", nil)
bind("SUPER + CTRL + code:13", "movetoworkspacesilent", "4", nil)
bind("SUPER + CTRL + code:14", "movetoworkspacesilent", "5", nil)
bind("SUPER + CTRL + code:15", "movetoworkspacesilent", "6", nil)
bind("SUPER + CTRL + code:16", "movetoworkspacesilent", "7", nil)
bind("SUPER + CTRL + code:17", "movetoworkspacesilent", "8", nil)
bind("SUPER + CTRL + code:18", "movetoworkspacesilent", "9", nil)
bind("SUPER + CTRL + code:19", "movetoworkspacesilent", "10", nil)
bind("SUPER + CTRL + bracketleft", "movetoworkspacesilent", "-1", nil)
bind("SUPER + CTRL + bracketright", "movetoworkspacesilent", "+1", nil)
bind("SUPER + mouse_down", "workspace", "e+1", nil)
bind("SUPER + mouse_up", "workspace", "e-1", nil)
bind("SUPER + period", "workspace", "e+1", nil)
bind("SUPER + comma", "workspace", "e-1", nil)
bind("SUPER + mouse:272", "movewindow", "", { mouse = true })
bind("SUPER + mouse:273", "resizewindow", "", { mouse = true })
bind("xf86KbdBrightnessDown", "exec", "$scriptsDir/BrightnessKbd.sh --dec", { repeating = true })
bind("xf86KbdBrightnessUp", "exec", "$scriptsDir/BrightnessKbd.sh --inc", { repeating = true })
bind("xf86Launch1", "exec", "rog-control-center", nil)
bind("xf86Launch3", "exec", "asusctl led-mode -n", nil)
bind("xf86Launch4", "exec", "asusctl profile -n", nil)
bind("xf86MonBrightnessDown", "exec", "$scriptsDir/Brightness.sh --dec", { repeating = true })
bind("xf86MonBrightnessUp", "exec", "$scriptsDir/Brightness.sh --inc", { repeating = true })
bind("xf86TouchpadToggle", "exec", "$scriptsDir/TouchPad.sh", nil)
bind("SUPER + F6", "exec", "$scriptsDir/ScreenShot.sh --now", nil)
bind("SUPER + SHIFT + F6", "exec", "$scriptsDir/ScreenShot.sh --area", nil)
bind("SUPER + CTRL + F6", "exec", "$scriptsDir/ScreenShot.sh --in5", nil)
bind("SUPER + ALT + F6", "exec", "$scriptsDir/ScreenShot.sh --in10", nil)
bind("ALT + F6", "exec", "$scriptsDir/ScreenShot.sh --active", nil)
bind("SUPER + D", "exec", "pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window", nil)
bind("SUPER + B", "exec", "xdg-open \"https://\"", nil)
bind("SUPER + Return", "exec", "$term", nil)
bind("SUPER + E", "exec", "$files", nil)
bind("SUPER + Y", "layoutmsg", "togglesplit", nil)
bind("ALT + SHIFT + tab", "cyclenext", "prev", nil)
bind("ALT + SHIFT + tab", "bringactivetotop", "", nil)
bind("SUPER + SHIFT + H", "exec", "$scriptsDir/KeyHints.sh", nil)
bind("SUPER + ALT + R", "exec", "$scriptsDir/Refresh.sh", nil)
bind("SUPER + ALT + E", "exec", "$scriptsDir/RofiEmoji.sh", nil)
bind("SUPER + SHIFT + G", "exec", "$scriptsDir/GameMode.sh", nil)
bind("SUPER + ALT + L", "exec", "$scriptsDir/ChangeLayout.sh", nil)
bind("SUPER + ALT + V", "exec", "$scriptsDir/ClipManager.sh", nil)
bind("SUPER + V", "exec", "$scriptsDir/ClipManager.sh", nil)
bind("SUPER + CTRL + R", "exec", "$scriptsDir/RofiThemeSelector.sh", nil)
bind("SUPER + CTRL + SHIFT + R", "exec", "pkill rofi || true && $scriptsDir/RofiThemeSelector-modified.sh", nil)
bind("SUPER + SHIFT + F", "fullscreen", "", nil)
bind("SUPER + CTRL + F", "fullscreen", "1", nil)
bind("SUPER + SPACE", "togglefloating", "", nil)
bind("SUPER + ALT + SPACE", "exec", "hyprctl dispatch workspaceopt allfloat", nil)
bind("SUPER + SHIFT + Return", "exec", "[float; move 15% 5%; size 70% 60%] $term", nil)
bind("SUPER + ALT + mouse_down", "exec", "hyprctl keyword misc:cursor_zoom_factor \"$(hyprctl getoption misc:cursor_zoom_factor | awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor * 2.0}')\"", nil)
bind("SUPER + ALT + mouse_up", "exec", "hyprctl keyword misc:cursor_zoom_factor \"$(hyprctl getoption misc:cursor_zoom_factor | awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor / 2.0}')\"", nil)
bind("SUPER + CTRL + ALT + B", "exec", "pkill -SIGUSR1 waybar", nil)
bind("SUPER + CTRL + B", "exec", "$scriptsDir/WaybarStyles.sh", nil)
bind("SUPER + ALT + B", "exec", "$scriptsDir/WaybarLayout.sh", nil)
bind("SUPER + SHIFT + M", "exec", "$UserScripts/RofiBeats.sh", nil)
bind("SUPER + W", "exec", "$UserScripts/WallpaperSelect.sh", nil)
bind("SUPER + SHIFT + W", "exec", "$UserScripts/WallpaperEffects.sh", nil)
bind("SUPER + CTRL + O", "exec", "hyprctl setprop active opaque toggle", nil)
bind("SUPER + SHIFT + K", "exec", "$scriptsDir/KeyBinds.sh", nil)
bind("SUPER + SHIFT + A", "exec", "$scriptsDir/Animations.sh", nil)
bind("SUPER + ALT + C", "exec", "$UserScripts/RofiCalc.sh", nil)
