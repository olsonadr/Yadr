--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")
local mytable       = awful.util.table or gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function (err)
        if in_error then return end

        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }

        in_error = false
    end)
end

-- }}}


-- {{{ Variable definitions

local themes = {
    "blackburn",	      -- 1
    "copland",         	      -- 2
    "dremora",         	      -- 3
    "holo",            	      -- 4
    "multicolor",      	      -- 5
    "powerarrow",      	      -- 6
    "powerarrow-dark", 	      -- 7
    "rainbow",         	      -- 8
    "steamburn",       	      -- 9
    "vertex",          	      -- 10
    "powerarrow-dark-custom", -- 11
}

local chosen_theme = themes[11]
--local modkey       = "Mod4"
--local altkey       = "Mod1"
--local modkey       = "Mod1"
local modkey       = "Mod4"
local altkey       = "Mod1"
--local altkey       = "Mod4"
--local terminal     = "gnome-terminal"
local terminal     = "kitty"
local vi_focus     = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true  -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "nvim"
local browser      = "brave-browser"
local scrlocker    = "lock"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
local dwindle_split_factors = setmetatable({}, { __mode = "k" })
local resizable_dwindle = { name = "dwindle" }

function resizable_dwindle.arrange(params)
    local clients = params.clients
    local area = params.workarea
    local x, y, width, height = area.x, area.y, area.width, area.height

    for index, c in ipairs(clients) do
        if index == #clients then
            params.geometries[c] = {
                x = x, y = y, width = width, height = height,
            }
        else
            local horizontal = index % 2 == 1
            local axis = horizontal and "horizontal" or "vertical"
            local factors = dwindle_split_factors[c] or {}
            local ratio = math.max(0.1, math.min(0.9, factors[axis] or 0.5))
            dwindle_split_factors[c] = factors

            if (horizontal and width < 2) or (not horizontal and height < 2) then
                params.geometries[c] = { x = x, y = y, width = width, height = height }
            elseif horizontal then
                local split = math.max(1, math.min(width - 1, math.floor(width * ratio)))
                params.geometries[c] = { x = x, y = y, width = split, height = height }
                x, width = x + split, width - split
            else
                local split = math.max(1, math.min(height - 1, math.floor(height * ratio)))
                params.geometries[c] = { x = x, y = y, width = width, height = split }
                y, height = y + split, height - split
            end
        end
    end
end

awful.layout.layouts = {
    resizable_dwindle,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.floating,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center
}

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

awful.util.taglist_buttons = mytable.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = mytable.join(
     awful.button({ }, 1, function(c)
         if c == client.focus then
             c.minimized = true
         else
             c:emit_signal("request::activate", "tasklist", { raise = true })
         end
     end),
     awful.button({ }, 3, function()
         awful.menu.client_list({ theme = { width = 250 } })
     end),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
beautiful.useless_gap = 1
beautiful.border_normal = "#EF6CF6"
beautiful.border_focus = "#96E3F8"

-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-- }}}

run_once({ "urxvtd", "unclutter -root" }) -- comma-separated entries
awful.spawn.with_shell("systemctl --user start kanata.service")

local function start_touchegg()
    awful.spawn.easy_async_with_shell("command -v touchegg >/dev/null 2>&1", function(_, _, _, exit_code)
        if exit_code ~= 0 then
            naughty.notify({
                title = "Touchpad gestures unavailable",
                text = "Install touchegg to enable Awesome touchpad gestures.",
            })
            return
        end

        awful.spawn.easy_async_with_shell(
            "systemctl --user import-environment DISPLAY XAUTHORITY XDG_SESSION_TYPE && " ..
            "systemctl --user start touchegg.service",
            function(_, stderr, _, start_exit_code)
                if start_exit_code ~= 0 then
                    naughty.notify({
                        title = "Could not start Touchégg",
                        text = stderr ~= "" and stderr or "Check touchegg.service logs.",
                    })
                end
            end
        )
    end)
end

start_touchegg()

-- This function implements the XDG autostart specification
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'albert ; ' ..
    'pasystray ; ' ..
    'setxkbmap -option ; ' ..
    'syndaemon -i 0.5 -t -K -R ; ' ..
    'xss-lock --transfer-sleep-lock -- ' .. scrlocker ..
    -- end commands
    'if command -v dex-autostart >/dev/null 2>&1; then dex-autostart --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"; elif command -v dex >/dev/null 2>&1; then dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"; fi' -- https://github.com/jceb/dex
)

-- }}}
-- {{{ Quit Func
function quit_awesome()
    awful.spawn("~/.config/awesome/shutdown.sh")
    awesome.quit()
end
-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", string.format("%s -e man awesome", terminal) },
   { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
   { "Restart", awesome.restart },
   { "Quit", quit_awesome },
}

awful.util.mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}

-- Hide titlebars unless floating
function hide_unless_floating(c)
    if not awful.titlebar then return end
    if c.floating then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end

--client.connect_signal("property::floating", hide_unless_floating)

-- Hide the menu when the mouse leaves it
--[[
awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not awful.util.mymainmenu.active_child or
       (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
       awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        awful.util.mymainmenu:hide()
    else
        awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
                awful.util.mymainmenu:hide()
            end
        end)
    end
end)
--]]

-- Set the Menubar terminal for applications that require it
--menubar.utils.terminal = terminal

-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}

-- {{{ Mouse bindings

root.buttons(mytable.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev),
    awful.button({ modkey }, 4, awful.tag.viewnext),
    awful.button({ modkey }, 5, awful.tag.viewprev),
    awful.button({ modkey, altkey }, 4, function () awful.layout.inc(1) end),
    awful.button({ modkey, altkey }, 5, function () awful.layout.inc(-1) end)
))

-- }}}

-- {{{ Key bindings

local function move_focused_to_tag(delta, follow)
    local c = client.focus
    if not c then return end
    local current = c.first_tag or awful.tag.selected(c.screen)
    local target = current and c.screen.tags[current.index + delta]
    if target then
        c:move_to_tag(target)
        if follow then target:view_only() end
    end
end

globalkeys = mytable.join(
    -- Destroy all notifications
    awful.key({ "Control",           }, "space", function() naughty.destroy_all_notifications() end,
              {description = "destroy all notifications", group = "hotkeys"}),
    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({ altkey }, "p", function() os.execute("screenshot") end,
              {description = "take a screenshot", group = "hotkeys"}),

    -- X screen locker
    -- awful.key({ modkey, "Shift" }, "l", function () os.execute(scrlocker) end,
    --           {description = "lock screen (alt)", group = "hotkeys"}),
    awful.key({ modkey, "Shift" }, "l", function () awful.spawn.with_shell("loginctl lock-session") end,
              {description = "lock screen", group = "hotkeys"}),

    -- Show help
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    -- Tag browsing
    awful.key({ modkey,           }, "Left", function ()
                  awful.client.focus.global_bydirection("left")
                  if client.focus then client.focus:raise() end
              end, {description = "focus left", group = "client"}),
    awful.key({ modkey,           }, "Right", function ()
                  awful.client.focus.global_bydirection("right")
                  if client.focus then client.focus:raise() end
              end, {description = "focus right", group = "client"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    awful.key({ altkey, "Control" }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ altkey, "Control" }, "Right", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By-direction client focus
    awful.key({ modkey }, "j", function () awful.client.focus.byidx(1) end,
              {description = "focus next", group = "client"}),
    awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1) end,
              {description = "focus previous", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Menu
    awful.key({ modkey,           }, "F1", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        awful.tag.viewnext,
        {description = "next workspace", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Tab", awful.tag.viewprev,
              {description = "previous workspace", group = "tag"}),

    -- Show/hide wibox
    awful.key({ modkey, "Shift" }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- On-the-fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ modkey, "Control", "Shift" }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Control", "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "move workspace left", group = "tag"}),
    awful.key({ modkey, "Control", "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "move workspace right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control", "Alt" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ "Control", "Alt" }, "Delete", quit_awesome,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, altkey    }, "Page_Up", function () awful.tag.incmwfact( 0.05)         end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, altkey    }, "Page_Down", function () awful.tag.incmwfact(-0.05)      end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control", altkey }, "Up", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control", altkey }, "Down", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function ()
                  if client.focus then
                      client.focus.floating = not client.focus.floating
                      client.focus:raise()
                  end
              end, {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n", function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
    end, {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    --awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
    --          {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"}),

    -- Screen brightness
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("brightnessctl set +100") end,
              {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("brightnessctl set 100-") end,
              {description = "-10%", group = "hotkeys"}),

    -- ALSA volume control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            os.execute(string.format("amixer -D pulse -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            os.execute(string.format("amixer -D pulse -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ altkey }, "m",
        function ()
            os.execute(string.format("amixer -D pulse -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "toggle mute", group = "hotkeys"}),
    awful.key({ altkey, "Control" }, "m",
        function ()
            os.execute(string.format("amixer -D pulse -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume 100%", group = "hotkeys"}),
    awful.key({ altkey, "Control" }, "0",
        function ()
            os.execute(string.format("amixer -D pulse -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume 0%", group = "hotkeys"}),

    -- MPD control
    -- awful.key({ altkey, "Control" }, "Up",
    --     function ()
    --         os.execute("mpc toggle")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc toggle", group = "widgets"}),
    -- awful.key({ altkey, "Control" }, "Down",
    --     function ()
    --         os.execute("mpc stop")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc stop", group = "widgets"}),
    -- awful.key({ altkey, "Control" }, "Left",
    --     function ()
    --         os.execute("mpc prev")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc prev", group = "widgets"}),
    -- awful.key({ altkey, "Control" }, "Right",
    --     function ()
    --         os.execute("mpc next")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc next", group = "widgets"}),
    awful.key({ altkey }, "0",
        function ()
            local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
            if beautiful.mpd.timer.started then
                beautiful.mpd.timer:stop()
                common.text = common.text .. lain.util.markup.bold("OFF")
            else
                beautiful.mpd.timer:start()
                common.text = common.text .. lain.util.markup.bold("ON")
            end
            naughty.notify(common)
        end,
        {description = "mpc on/off", group = "widgets"}),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
              {description = "copy terminal to gtk", group = "hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey, "Shift" }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
              {description = "copy gtk to terminal", group = "hotkeys"}),

    -- User programs
    awful.key({ modkey }, "q", function () if client.focus then client.focus:kill() end end,
              {description = "close active window", group = "client"}),

    -- Default
    --[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    --]]
    --[[ dmenu
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}),
    --]]
    -- alternatively use rofi, a dmenu-like application with more features
    -- check https://github.com/DaveDavenport/rofi for more details
    --[[ rofi
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("rofi -show %s -theme %s",
            'run', 'dmenu'))
        end,
        {description = "show rofi", group = "launcher"}),
    --]]
    -- Prompt
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
    --]]
)

clientkeys = mytable.join(
    -- Mine
    -- Toggle titlebar
    awful.key({ "Control", "Shift", modkey, altkey }, "t", function(c) awful.titlebar.toggle(c) end,
	      {description="toggle titlebar", group="client"}),

    -- Default
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey, altkey    }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Control", "Alt" }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Hyprland uses workspaces 1-10, with keycodes for layout-independent digits.
for i = 1, 10 do
    local tag_index = i
    local keycode = i == 10 and 19 or i + 9
    globalkeys = mytable.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. keycode,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[tag_index]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..tag_index, group = "tag"}),
        -- Move the client to a tag and follow.
        awful.key({ modkey, "Shift" }, "#" .. keycode,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[tag_index]
                          if tag then
                              client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                      end
                  end,
                  {description = "move client to tag #"..tag_index, group = "tag"}),
        -- Move the client without changing the visible tag.
        awful.key({ modkey, "Control" }, "#" .. keycode,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[tag_index]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move client silently to tag #"..tag_index, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. keycode,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[tag_index]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle client on tag #" .. tag_index, group = "tag"})
    )
end

local rofi_config = os.getenv("HOME") .. "/.config/rofi/config.rasi"
local rofi_command = "rofi -config '" .. rofi_config .. "'"
local saved_layouts = setmetatable({}, { __mode = "k" })

local function launch_rofi(mode)
    awful.spawn.with_shell("pkill -x rofi >/dev/null 2>&1 || true; " ..
        rofi_command .. " " .. mode)
end

local function toggle_dwindle()
    local tag = awful.tag.selected()
    if tag then
        tag.layout = tag.layout == resizable_dwindle and awful.layout.suit.tile or resizable_dwindle
    end
end

local function toggle_floating_layout()
    local tag = awful.tag.selected()
    if not tag then return end
    if tag.layout == awful.layout.suit.floating then
        tag.layout = saved_layouts[tag] or awful.layout.suit.tile
        saved_layouts[tag] = nil
    else
        saved_layouts[tag] = tag.layout
        tag.layout = awful.layout.suit.floating
    end
end

local function resize_focused(dx, dy)
    local c = client.focus
    if not c then return end

    if c.floating then
        c:relative_move(0, 0, dx, dy)
        return
    end

    local tag = c.screen.selected_tag
    if not tag then return end

    if tag.layout == resizable_dwindle then
        local clients = awful.client.tiled(c.screen)
        local index
        for i, tiled_client in ipairs(clients) do
            if tiled_client == c then
                index = i
                break
            end
        end
        if not index then return end

        local horizontal = dx ~= 0
        local split_index
        for i = index, 1, -1 do
            if (i % 2 == 1) == horizontal then
                split_index = i
                break
            end
        end
        if not split_index then return end

        local splitter = clients[split_index]
        local factors = dwindle_split_factors[splitter] or {}
        local axis = horizontal and "horizontal" or "vertical"
        local delta = (horizontal and dx or dy) > 0 and 0.04 or -0.04
        if split_index < index then delta = -delta end
        factors[axis] = math.max(0.1, math.min(0.9, (factors[axis] or 0.5) + delta))
        dwindle_split_factors[splitter] = factors
        awful.layout.arrange(c.screen)
        return
    end

    local tile_layouts = {
        [awful.layout.suit.tile] = true,
        [awful.layout.suit.tile.left] = true,
        [awful.layout.suit.tile.right] = true,
        [awful.layout.suit.tile.top] = true,
        [awful.layout.suit.tile.bottom] = true,
    }
    if not tile_layouts[tag.layout] then return end

    if dx ~= 0 then
        local delta = dx > 0 and 0.025 or -0.025
        if c ~= awful.client.getmaster(c.screen) then delta = -delta end
        awful.tag.incmwfact(delta, tag)
    end
    if dy ~= 0 then
        awful.client.incwfact(dy > 0 and 0.05 or -0.05, c)
    end
end

local function swap_focused(direction)
    local c = client.focus
    if not c then return end
    if c.floating then
        local delta = 50
        local x = direction == "left" and -delta or direction == "right" and delta or 0
        local y = direction == "up" and -delta or direction == "down" and delta or 0
        c:relative_move(x, y, 0, 0)
    else
        awful.client.swap.bydirection(direction, c)
    end
end

local function toggle_sticky()
    if client.focus then
        client.focus.sticky = not client.focus.sticky
        client.focus:raise()
    end
end

local function toggle_opacity()
    if client.focus then
        client.focus.opacity = client.focus.opacity < 1 and 1 or 0.85
    end
end

local function toggle_bars()
    for s in screen do
        if s.mywibox then s.mywibox.visible = not s.mywibox.visible end
        if s.mybottomwibox then s.mybottomwibox.visible = not s.mybottomwibox.visible end
    end
end

local function take_screenshot(options)
    local directory = os.getenv("HOME") .. "/Pictures/Screenshots"
    local filename = directory .. "/Screenshot_%Y-%m-%d_%H-%M-%S.png"
    awful.spawn.with_shell("mkdir -p '" .. directory .. "' && scrot " ..
        options .. " '" .. filename .. "'")
end

local function select_wallpaper(mode)
    local directory = os.getenv("HOME") .. "/Pictures/wallpapers"
    local command = "selected=$(find '" .. directory ..
        "' -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \\) " ..
        "-print | " .. rofi_command .. " -dmenu -i -p Wallpaper); " ..
        "[ -n \"$selected\" ] && feh " .. mode .. " \"$selected\""
    awful.spawn.with_shell(command)
end

local function show_power_menu()
    local command = "choice=$(printf 'Lock\\nSuspend\\nReboot\\nPower Off\\n' | " ..
        rofi_command .. " -dmenu -i -p Power); " ..
        "case \"$choice\" in Lock) loginctl lock-session;; " ..
        "Suspend) systemctl suspend;; Reboot) systemctl reboot;; " ..
        "'Power Off') systemctl poweroff;; esac"
    awful.spawn.with_shell(command)
end

local function show_clipboard()
    awful.spawn.with_shell(
        "xclip -selection clipboard -o 2>/dev/null | " ..
        rofi_command .. " -dmenu -i -p Clipboard | " ..
        "xclip -selection clipboard")
end

local function kill_focused_process()
    if client.focus and type(client.focus.pid) == "number" then
        awful.spawn.with_shell("kill -TERM " .. client.focus.pid)
    end
end

local function screenshot_key(modifiers, key, options, description)
    return awful.key(modifiers, key, function () take_screenshot(options) end,
        {description = description, group = "screenshot"})
end

globalkeys = mytable.join(globalkeys,
    awful.key({ modkey, "Shift" }, "q", kill_focused_process,
        {description = "terminate active client", group = "client"}),
    awful.key({ modkey }, "b", function () awful.spawn.with_shell("xdg-open https://") end,
        {description = "open browser", group = "launcher"}),
    awful.key({ modkey }, "d", function ()
        launch_rofi("-show drun -modi drun,filebrowser,run,window")
    end, {description = "application launcher", group = "launcher"}),
    awful.key({ modkey }, "e", function () awful.spawn("nautilus") end,
        {description = "file manager", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "e", function ()
        launch_rofi("-show drun -modi drun,filebrowser,run,window")
    end, {description = "settings launcher", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "h", function ()
        hotkeys_popup.show_help(nil, awful.screen.focused())
    end, {description = "show keybindings", group = "awesome"}),
    awful.key({ modkey }, "y", toggle_dwindle,
        {description = "toggle split layout", group = "layout"}),
    awful.key({ modkey }, "p", toggle_dwindle,
        {description = "toggle pseudo layout", group = "layout"}),
    awful.key({ modkey }, "i", function () awful.tag.incnmaster(1, nil, true) end,
        {description = "add master client", group = "layout"}),
    awful.key({ modkey, "Control" }, "d", function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "remove master client", group = "layout"}),
    awful.key({ modkey }, "m", function () awful.tag.setmwfact(0.3) end,
        {description = "set master ratio", group = "layout"}),
    awful.key({ modkey }, "g", toggle_sticky,
        {description = "toggle sticky client group", group = "client"}),
    awful.key({ modkey, "Control" }, "Tab", function () awful.client.focus.byidx(1) end,
        {description = "cycle active client", group = "client"}),
    awful.key({ "Alt" }, "Tab", function () awful.client.focus.byidx(1) end,
        {description = "cycle windows", group = "client"}),
    awful.key({ "Alt", "Shift" }, "Tab", function () awful.client.focus.byidx(-1) end,
        {description = "cycle windows backwards", group = "client"}),
    awful.key({ modkey, "Shift" }, "n", function () naughty.destroy_all_notifications() end,
        {description = "dismiss notifications", group = "notifications"}),
    awful.key({ modkey, "Control" }, "Return", function ()
        if client.focus then client.focus:swap(awful.client.getmaster()) end
    end, {description = "swap with master", group = "client"}),
    awful.key({ modkey, "Shift" }, "u", function ()
        if client.focus then client.focus.sticky = true end
    end, {description = "move client to special workspace", group = "client"}),
    awful.key({ modkey }, "u", toggle_sticky,
        {description = "toggle special workspace client", group = "client"}),
    awful.key({ modkey, "Shift" }, "f", function ()
        if client.focus then client.focus.fullscreen = not client.focus.fullscreen end
    end, {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Control" }, "f", function ()
        if client.focus then client.focus.maximized = not client.focus.maximized end
    end, {description = "toggle maximized", group = "client"}),
    awful.key({ modkey, "Shift" }, "Return", function ()
        awful.screen.focused().quake:toggle()
    end, {description = "toggle dropdown terminal", group = "launcher"}),
    awful.key({ modkey, "Alt" }, "r", awesome.restart,
        {description = "refresh Awesome", group = "awesome"}),
    awful.key({ modkey, "Alt" }, "e", function ()
        launch_rofi("-show drun -modi drun,filebrowser,run,window")
    end, {description = "emoji launcher", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "g", toggle_dwindle,
        {description = "toggle game layout", group = "layout"}),
    awful.key({ modkey, "Alt" }, "l", toggle_dwindle,
        {description = "change layout", group = "layout"}),
    awful.key({ modkey }, "v", show_clipboard,
        {description = "clipboard menu", group = "launcher"}),
    awful.key({ modkey, "Alt" }, "v", show_clipboard,
        {description = "clipboard menu", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", function ()
        awful.spawn.with_shell(os.getenv("HOME") .. "/.config/hypr/scripts/RofiThemeSelector.sh")
    end, {description = "select Rofi theme", group = "launcher"}),
    awful.key({ modkey, "Control", "Shift" }, "r", function ()
        awful.spawn.with_shell(os.getenv("HOME") .. "/.config/hypr/scripts/RofiThemeSelector-modified.sh")
    end, {description = "select Rofi theme", group = "launcher"}),
    awful.key({ modkey, "Alt" }, "space", toggle_floating_layout,
        {description = "toggle all-floating layout", group = "layout"}),
    awful.key({ modkey, "Alt" }, "b", function ()
        launch_rofi("-show drun -modi drun,filebrowser,run,window")
    end, {description = "Awesome layout menu", group = "launcher"}),
    awful.key({ modkey, "Control" }, "b", function ()
        launch_rofi("-show drun -modi drun,filebrowser,run,window")
    end, {description = "Awesome style menu", group = "launcher"}),
    awful.key({ modkey, "Control", "Alt" }, "b", toggle_bars,
        {description = "toggle Awesome bars", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "m", function ()
        awful.spawn.with_shell(os.getenv("HOME") .. "/.config/hypr/UserScripts/RofiBeats.sh")
    end, {description = "Rofi music menu", group = "launcher"}),
    awful.key({ modkey }, "w", function ()
        select_wallpaper("--bg-fill")
    end, {description = "select wallpaper", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "w", function ()
        select_wallpaper("--bg-scale")
    end, {description = "select scaled wallpaper", group = "launcher"}),
    awful.key({ modkey, "Control" }, "o", toggle_opacity,
        {description = "toggle opacity", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function ()
        hotkeys_popup.show_help(nil, awful.screen.focused())
    end, {description = "search keybindings", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "a", toggle_dwindle,
        {description = "toggle animation layout", group = "layout"}),
    awful.key({ modkey, "Alt" }, "c", function () awful.spawn("qalculate-gtk") end,
        {description = "calculator", group = "launcher"}),
    awful.key({ "Control", "Alt" }, "p", show_power_menu,
        {description = "power menu", group = "system"}),
    awful.key({ "Control", "Alt" }, "l", function ()
        awful.spawn.with_shell("loginctl lock-session")
    end, {description = "lock screen", group = "system"}),
    awful.key({ modkey, "Alt" }, "Left", function () swap_focused("left") end,
        {description = "swap window left", group = "client"}),
    awful.key({ modkey, "Alt" }, "Right", function () swap_focused("right") end,
        {description = "swap window right", group = "client"}),
    awful.key({ modkey, "Alt" }, "Up", function () swap_focused("up") end,
        {description = "swap window up", group = "client"}),
    awful.key({ modkey, "Alt" }, "Down", function () swap_focused("down") end,
        {description = "swap window down", group = "client"}),
    awful.key({ modkey, "Control" }, "Left", function () swap_focused("left") end,
        {description = "move window left", group = "client"}),
    awful.key({ modkey, "Control" }, "Right", function () swap_focused("right") end,
        {description = "move window right", group = "client"}),
    awful.key({ modkey, "Control" }, "Up", function () swap_focused("up") end,
        {description = "move window up", group = "client"}),
    awful.key({ modkey, "Control" }, "Down", function () swap_focused("down") end,
        {description = "move window down", group = "client"}),
    awful.key({ modkey, "Shift" }, "Up", function () resize_focused(0, -50) end,
        {description = "resize window up", group = "client"}),
    awful.key({ modkey, "Shift" }, "Down", function () resize_focused(0, 50) end,
        {description = "resize window down", group = "client"}),
    awful.key({ modkey, "Shift" }, "Left", function () resize_focused(-50, 0) end,
        {description = "resize window left", group = "client"}),
    awful.key({ modkey, "Shift" }, "Right", function () resize_focused(50, 0) end,
        {description = "resize window right", group = "client"}),
    awful.key({ modkey }, "Up", function ()
        awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end
    end, {description = "focus up", group = "client"}),
    awful.key({ modkey }, "Down", function ()
        awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end
    end, {description = "focus down", group = "client"}),
    awful.key({ modkey }, "comma", awful.tag.viewprev,
        {description = "previous workspace", group = "tag"}),
    awful.key({ modkey }, "period", awful.tag.viewnext,
        {description = "next workspace", group = "tag"}),
    awful.key({ modkey, "Shift" }, "bracketleft", function () move_focused_to_tag(-1, true) end,
        {description = "move client to previous workspace", group = "tag"}),
    awful.key({ modkey, "Shift" }, "bracketright", function () move_focused_to_tag(1, true) end,
        {description = "move client to next workspace", group = "tag"}),
    awful.key({ modkey, "Control" }, "bracketleft", function () move_focused_to_tag(-1, false) end,
        {description = "move client silently to previous workspace", group = "tag"}),
    awful.key({ modkey, "Control" }, "bracketright", function () move_focused_to_tag(1, false) end,
        {description = "move client silently to next workspace", group = "tag"}),
    awful.key({ }, "XF86AudioRaiseVolume", function ()
        awful.spawn.with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
    end, {description = "volume up", group = "media"}),
    awful.key({ }, "XF86AudioLowerVolume", function ()
        awful.spawn.with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
    end, {description = "volume down", group = "media"}),
    awful.key({ }, "XF86AudioMute", function ()
        awful.spawn.with_shell("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
    end, {description = "mute audio", group = "media"}),
    awful.key({ }, "XF86AudioMicMute", function ()
        awful.spawn.with_shell("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
    end, {description = "mute microphone", group = "media"}),
    awful.key({ }, "XF86Sleep", function () awful.spawn.with_shell("systemctl suspend") end,
        {description = "suspend", group = "system"}),
    awful.key({ }, "XF86Rfkill", function ()
        awful.spawn.with_shell(os.getenv("HOME") .. "/.config/hypr/scripts/AirplaneMode.sh")
    end, {description = "toggle airplane mode", group = "system"}),
    awful.key({ }, "XF86AudioPlay", function () awful.spawn.with_shell("playerctl play-pause") end,
        {description = "play/pause", group = "media"}),
    awful.key({ }, "XF86AudioPause", function () awful.spawn.with_shell("playerctl play-pause") end,
        {description = "play/pause", group = "media"}),
    awful.key({ }, "XF86AudioPlayPause", function () awful.spawn.with_shell("playerctl play-pause") end,
        {description = "play/pause", group = "media"}),
    awful.key({ }, "XF86AudioNext", function () awful.spawn.with_shell("playerctl next") end,
        {description = "next track", group = "media"}),
    awful.key({ }, "XF86AudioPrev", function () awful.spawn.with_shell("playerctl previous") end,
        {description = "previous track", group = "media"}),
    awful.key({ }, "XF86AudioStop", function () awful.spawn.with_shell("playerctl stop") end,
        {description = "stop playback", group = "media"}),
    awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.spawn.with_shell("brightnessctl set 5%-")
    end, {description = "brightness down", group = "system"}),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.spawn.with_shell("brightnessctl set 5%+")
    end, {description = "brightness up", group = "system"}),
    awful.key({ }, "XF86KbdBrightnessDown", function ()
        awful.spawn.with_shell(os.getenv("HOME") .. "/.config/hypr/scripts/BrightnessKbd.sh --dec")
    end, {description = "keyboard brightness down", group = "system"}),
    awful.key({ }, "XF86KbdBrightnessUp", function ()
        awful.spawn.with_shell(os.getenv("HOME") .. "/.config/hypr/scripts/BrightnessKbd.sh --inc")
    end, {description = "keyboard brightness up", group = "system"}),
    awful.key({ }, "XF86Launch1", function ()
        awful.spawn.with_shell("command -v rog-control-center >/dev/null && rog-control-center || " ..
            "rofi -config '" .. rofi_config .. "' -show drun")
    end, {description = "hardware control panel", group = "system"}),
    awful.key({ }, "XF86Launch3", function ()
        awful.spawn.with_shell("command -v asusctl >/dev/null && asusctl led-mode -n || " ..
            "rofi -config '" .. rofi_config .. "' -show drun")
    end, {description = "hardware lighting mode", group = "system"}),
    awful.key({ }, "XF86Launch4", function ()
        awful.spawn.with_shell("command -v asusctl >/dev/null && asusctl profile -n || " ..
            "rofi -config '" .. rofi_config .. "' -show drun")
    end, {description = "hardware performance profile", group = "system"}),
    awful.key({ }, "XF86TouchpadToggle", function ()
        awful.spawn.with_shell("id=$(xinput list --id-only '.*[Tt]ouchpad.*' | head -n1); " ..
            "if [ -n \"$id\" ]; then state=$(xinput list-props \"$id\" | " ..
            "awk -F': ' '/Device Enabled/ {print $2; exit}'); " ..
            "if [ \"$state\" = 1 ]; then xinput disable \"$id\"; else xinput enable \"$id\"; fi; fi")
    end, {description = "toggle touchpad", group = "system"}),
    awful.key({ }, "Print", function () take_screenshot("") end,
        {description = "screenshot", group = "screenshot"}),
    screenshot_key({ modkey }, "Print", "", "screenshot"),
    screenshot_key({ modkey, "Shift" }, "Print", "-s", "select screenshot area"),
    screenshot_key({ modkey, "Control" }, "Print", "-d 5", "delayed screenshot"),
    screenshot_key({ modkey, "Control", "Shift" }, "Print", "-d 10", "delayed screenshot"),
    screenshot_key({ "Alt" }, "Print", "-u", "active window screenshot"),
    screenshot_key({ modkey, "Shift" }, "s", "-s", "select screenshot area"),
    screenshot_key({ modkey }, "F6", "", "screenshot"),
    screenshot_key({ modkey, "Shift" }, "F6", "-s", "select screenshot area"),
    screenshot_key({ modkey, "Control" }, "F6", "-d 5", "delayed screenshot"),
    screenshot_key({ modkey, "Alt" }, "F6", "-d 10", "delayed screenshot"),
    screenshot_key({ "Alt" }, "F6", "-u", "active window screenshot")
)

clientbuttons = mytable.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     callback = awful.client.setslave,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
function titlebar_callback(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = mytable.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 24 }) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
    awful.titlebar.hide(c)
    --hide_unless_floating(c)
end
client.connect_signal("request::titlebars", titlebar_callback)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)


-- }}}

-- -- Start autorun programs
-- awful.spawn.with_shell("~/.config/awesome/autorun.sh")
awful.spawn.with_shell("pasystray")

-- Limit size of notification icons
naughty.config.defaults['icon_size'] = 100
