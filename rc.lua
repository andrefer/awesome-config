-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local drop      = require("scratchdrop")
local lain      = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/embuh/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano" or "vi"
editor_cmd = terminal .. " -e " .. editor

-- user defined
root_terminal = "urxvt -e su - "
browser    = "firefox"
editor_gui = "geany"
musics	= "audacious"
tmusics = terminal .. " -e mocp "
fileman	= "pcmanfm"
tfile = terminal .. " -e mc"
mail       = terminal .. " -e mutt "
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
   names = { "MAIN", "TERM", "DEVEL", "MEDIA", "DOCS", "MISC"},
   layout = { layouts[1], layouts[2], layouts[12], layouts[1], layouts[12], layouts[1]}
}

for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "-------START-------",""},
   { "switch theme", terminal .. " -e .config/awesome/switch-theme.sh", beautiful.awesome_icon},
   { "manual", terminal .. " -e man awesome", beautiful.awesome_icon },
   { "edit config", editor_gui .. " " .. awesome.conffile, beautiful.awesome_icon },
   { "restart", awesome.restart, beautiful.awesome_icon },
   { "quit", awesome.quit, beautiful.awesome_icon },
   { "--------END--------",""},
}

display = {
	{ "mirror display", "xrandr --output VGA-0 --auto", beautiful.awesome_icon },
	{ "disable mirror display", "xrandr --output VGA-0 --off", beautiful.awesome_icon },
}
	
mysql = {
	{ "-------START-------",""},
	{ "start", "urxvt -e su -l root -c '/etc/rc.d/rc.mysqld start'", beautiful.awesome_icon },
	{ "stop", "urxvt -e su -l root -c '/etc/rc.d/rc.mysqld stop'", beautiful.awesome_icon },
	{ "restart", "urxvt -e su -l root -c '/etc/rc.d/rc.mysqld restart'", beautiful.awesome_icon },
	{ "--------END--------",""},
}
	
apache = {
	{ "-------START-------",""},
	{ "start", "urxvt -e su -c -m - '/etc/rc.d/rc.httpd start' root", beautiful.awesome_icon },
	{ "stop", "urxvt -e su -c '/etc/rc.d/rc.httpd stop'", beautiful.awesome_icon },
	{ "restart", "urxvt -e su -c '/etc/rc.d/rc.httpd restart'", beautiful.awesome_icon },
	{ "--------END--------",""},
}
	
services = {
	{ "-------START-------",""},
	{ "Apache", apache, beautiful.awesome_icon },
	{ "MySQL | MariaDB", mysql, beautiful.awesome_icon },
	{ "--------END--------",""},
}

slack = {
	{ "-------START-------",""},
	{"Update GPG", "urxvt -e su -c 'slackpkg update gpg'", beautiful.awesome_icon },
	{"Update", "urxvt -e su -c 'slackpkg update'", beautiful.awesome_icon },
	{"Upgrade-all", "urxvt -e su -c 'slackpkg upgrade-all'", beautiful.awesome_icon },
	{"Clean-System", "urxvt -e su -c 'slackpkg clean-system'", beautiful.awesome_icon },
	{"New Config", "urxvt -e su -c 'slackpkg new-config'", beautiful.awesome_icon },
	{ "--------END--------",""},
}
	
package = {
	{ "-------START-------",""},
	{"Pkgtool", "urxvt -e su -c pkgtool", beautiful.awesome_icon },
	{ "-------------------",""},
	{ "Slackpkg", slack, beautiful.awesome_icon },
	{ "-------------------",""},
	{"SBopkg", "urxvt -e su -c sbopkg", beautiful.awesome_icon },
	{ "--------END--------",""},
}

system = {
	{ "-------START-------",""},
	{ "Edit Lilo", "gksu geany /etc/lilo.conf", beautiful.awesome_icon },
	{ "Lilo Config", "urxvt -e su -c liloconfig", beautiful.awesome_icon },
	{ "--------END--------",""},
}
settings = {
	{ "-------START-------",""},
	{ "Display", display, beautiful.awesome_icon },
	{ "Regen Menu", "urxvt -e xdg_menu --format awesome --fullmenu  --root-menu /etc/kde/xdg/menus/applications.menu > ~/.config/awesome/menu.lua", beautiful.awesome_icon},
	{ "Regen TreeFiles", "urxvt -e .config/awesome/file_tree_menu.py", beautiful.awesome_icon },
	{ "-------------------",""},
	{ "Services", services, beautiful.awesome_icon },
	{ "Boot Loader", system, beautiful.awesome_icon },
	{ "--------END--------",""},
}

xdg_menu = require("menu")
--genMenu = require('filesmenu') 
mymainmenu = awful.menu.new({ items = { 
                                    { "-------START-------",""},
                                    { "Run", "gmrun -p", beautiful.awesome_icon},
                                    { "-------------------",""},
                                    { "Applications", xdgmenu, beautiful.awesome_icon },
                                    { "-------------------",""},
                                    { "Root File Manager","urxvt -e su -c " .. fileman, beautiful.awesome_icon},
                                    { "Root Term Emulator",root_terminal, beautiful.awesome_icon},
                                    { "-------------------",""},
                                    { "Files", require("myplacesmenu").myplacesmenu(), beautiful.awesome_icon},
                                    { "-------------------",""},
                                    { "Settings", settings, beautiful.awesome_icon},
                                    { "Manage Package", package, beautiful.awesome_icon},
									{ "-------------------",""},
									{ "Awesome", myawesomemenu, beautiful.awesome_icon},
                                    { "-------------------",""},
                                    { "Shutdhown", "sh .config/awesome/shutdown_dialog.sh", beautiful.awesome_icon},
                                    { "--------END--------",""},
                                  }
								  })


--[[
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
--]]

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
markup = lain.util.markup
separators = lain.util.separators

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
--mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")

mytextclock = lain.widgets.abase({
    timeout  = 60,
    cmd      = "date +'%a %d %b %R'",
    settings = function()
        widget:set_text(" " .. output)
    end
})

-- calendar
lain.widgets.calendar:attach(mytextclock, { font_size = 10 })

-- Mail IMAP check
mailicon = wibox.widget.imagebox(beautiful.widget_mail)
mailicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail) end)))
--[[ commented because it needs to be set before use
mailwidget = lain.widgets.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            widget:set_text(" " .. mailcount .. " ")
            mailicon:set_image(beautiful.widget_mail_on)
        else
            widget:set_text("")
            mailicon:set_image(beautiful.widget_mail)
        end
    end
})
--]]

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
})

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_text(" " .. coretemp_now .. "°C ")
    end
})

-- / fs
fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fswidget = lain.widgets.fs({
    settings  = function()
        widget:set_text(" " .. fs_now.used .. "% ")
    end
})

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widgets.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            widget:set_markup(" AC ")
            baticon:set_image(beautiful.widget_ac)
            return
        elseif tonumber(bat_now.perc) <= 5 then
            baticon:set_image(beautiful.widget_battery_empty)
        elseif tonumber(bat_now.perc) <= 15 then
            baticon:set_image(beautiful.widget_battery_low)
        else
            baticon:set_image(beautiful.widget_battery)
        end
        widget:set_markup(" " .. bat_now.perc .. "% ")
    end
})

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volumewidget = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(beautiful.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(beautiful.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(beautiful.widget_vol_low)
        else
            volicon:set_image(beautiful.widget_vol)
        end

        widget:set_text(" " .. volume_now.level .. "% ")
    end
})

-- Net
neticon = wibox.widget.imagebox(beautiful.widget_net)
neticon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))
netwidget = lain.widgets.net({
    settings = function()
        widget:set_markup(markup("#7AC82E", " " .. net_now.received)
                          .. " " ..
                          markup("#46A8C3", " " .. net_now.sent .. " "))
    end
})

-- Separators
spr = wibox.widget.textbox(' ')
spr2 = wibox.widget.textbox('|')
sprr = wibox.widget.textbox('-> ')
text = wibox.widget.textbox(' ALIEN ')

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(sprr)
    left_layout:add(mypromptbox[s])
    left_layout:add(spr)
	
	-- Widgets that are aligned to the upper right
    local right_layout_toggle = true
    local function right_layout_add (...)
        local arg = {...}
        if right_layout_toggle then
            right_layout:add(spr2)
            for i, n in pairs(arg) do
                right_layout:add(n)
            end
        else
            right_layout:add(spr2)
            for i, n in pairs(arg) do
                right_layout:add(n)
            end
        end
        right_layout_toggle = not right_layout_toggle
    end
    
    -- Widgets that are aligned to the right
    --local right_layout = wibox.layout.fixed.horizontal()
    right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spr2)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    --right_layout_add(neticon,netwidget)
    --right_layout_add(mailicon, mailwidget)
    right_layout_add(memicon, memwidget)
    right_layout_add(cpuicon, cpuwidget)
    right_layout_add(tempicon, tempwidget)
    right_layout_add(fsicon, fswidget)
    right_layout_add(volicon, volumewidget)
    right_layout_add(baticon, batwidget)
    right_layout_add(mytextclock, spr )
    right_layout_add(text, mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	-- Take a screenshot
    awful.key({ }, "Print", function () awful.util.spawn("xfce4-screenshooter") end),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Shift"    }, "e",      function () awful.util.spawn(editor_gui .. " " .. awesome.conffile) end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),
    
    -- Dropdown terminal
    awful.key({ modkey,	          }, "z",      function () drop(terminal) end),
    
    -- Widgets popups
    awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(5) end),
    awful.key({ altkey,           }, "h",      function () fswidget.show(5) end),
    
    -- ALSA volume control
    awful.key({ }, "XF86AudioRaiseVolume", function ()
       awful.util.spawn("amixer set Master 2%+", false) end),
   awful.key({ }, "XF86AudioLowerVolume", function ()
       awful.util.spawn("amixer set Master 2%-", false) end),
   awful.key({ }, "XF86AudioMute", function ()
       awful.util.spawn("amixer set Master toggle", false) end),
       
    awful.key({ altkey , "Control" }, "Up",
        function ()
            os.execute(string.format("amixer set %s 2%%+", volumewidget.channel))
            volumewidget.update()
        end),--]]
    awful.key({ altkey , "Control" }, "Down",
        function ()
            os.execute(string.format("amixer set %s 2%%-", volumewidget.channel))
            volumewidget.update()
        end),
    awful.key({ altkey , "Control"}, "m",
        function ()
            os.execute(string.format("amixer set %s toggle", volumewidget.channel))
            volumewidget.update()
        end),
    awful.key({ altkey , "Control" }, "m",
        function ()
            os.execute(string.format("amixer set %s 100%%", volumewidget.channel))
            volumewidget.update()
        end),
        
    -- User programs
    awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
    awful.key({ modkey }, "a", function () awful.util.spawn(musics) end),
    awful.key({ modkey, "Shift" }, "a", function () awful.util.spawn(tmusics) end),
    awful.key({ modkey }, "s", function () awful.util.spawn(fileman) end),
    awful.key({ modkey, "Shift"}, "s", function () awful.util.spawn(tfile) end),
    awful.key({ modkey, "Control" }, "s", function () awful.util.spawn( terminal .. " -e mc" ) end),
    awful.key({ modkey }, "e", function () awful.util.spawn(editor_gui) end),
    awful.key({ modkey, "Control" }, "a", function () awful.util.spawn(tmusics) end),
    awful.key({ modkey }, "h", function () awful.util.spawn(terminal .. " -e htop") end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ altkey }, "F2", function () awful.util.spawn( "gmrun" ) end),
    awful.key({ altkey }, "F3", function () awful.util.spawn( "dmenu_run -b" ) end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

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
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
      
    { rule_any = { class = {"Gimp", "Inkscape"} },
      properties = { tag = tags[1][4],
					 floating = true } },
      
    { rule_any = { class = {"Firefox","Google-chrome", "Opera", "Chromium", "Browser", "Chromiom-Browser"} },
      properties = { tag = tags[1][1] } },
      
    { rule = { class = "VirtualBox" },
	  except = { name = "Oracle VM VirtualBox Manager" },
	  properties = { floating = true } },
  
    { rule_any = { 
		class = {"Urxvt", "Uxterm", "Xterm" } },
        properties = { opacity = 0.95, floating = true } },

    { rule_any = { 
		class = {"MPlayer", "Smplayer", "Exaile", "Audacious","Audacity"} },
        properties = { floating = true, tag = tags[1][4] } },
          
    { rule = { instance = "plugin-container" },
          properties = { floating = true } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized_horizontal = true,
                         maximized_vertical = true } },
    { rule = { 
        name = "File Operation Progress" },
        properties = { floating = true } },
                   
    -- Set Geany to always map on screen 1 and tag number 3
    { rule_any = { 
        class = { "Wps", "Wpp", "Geany", "Masterpdfeditor" , "FBReader"} },
        properties = { tag = tags[1][5], focus = true } },
        
    { rule_any = { 
        class = {"Sublime_text" ,"Atom", "Pingendo", "IonicLab"} },
        properties = { tag = tags[1][3], focus = true } },
        
    { rule_any = { 
        class = { "Pidgin", "Xchat", "Skype" } }, 
        except_any = { role = { "conversation" } },
        properties = { tag = tags[1][6] } }, 
        
    { rule_any = { 
		class = {"Thunar", "Pcmanfm" } },
       properties = { tag = tags[1][6] } },
       
    { rule_any = { class = {"Transmission-gtk", "VirtualBox", "Genymotion", "Dukto", "Steam"} },
       properties = { tag = tags[1][6] },
    },
    
    -- Make Gloobus behave as expected
    { rule = { class = "Gloobus-preview-configuration" },
      properties = { floating = true } },
    { rule = { class = "Gloobus-preview" },
      properties = { floating = true,
      			 border_width = 0 } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

awful.util.spawn_with_shell("compton -cC")
awful.util.spawn_with_shell("nm-applet")
