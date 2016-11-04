
--[[                       
       Embuh Config                                          
--]]

theme                               = {}

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/embuh"
--theme.wallpaper                     = "PATH Image"

theme.font                          = "Terminus 8"
theme.fg_normal                     = "#BFBFBF"
theme.fg_focus                      = "#7F7F7F"
theme.fg_urgent                     = "#CF1B1B"
theme.bg_normal                     = "#1A1A1A"
theme.bg_focus                      = "#4D4D4D"
theme.bg_urgent                     = "#1A1A1A"
theme.border_width                  = "1"
theme.border_normal                 = "#3F3F3F"
theme.border_focus                  = "#7F7F7F"
theme.border_marked                 = "#CC9393"
theme.titlebar_bg_focus             = "#E5E5E5"
theme.titlebar_bg_normal            = "#1A1A1A"
theme.taglist_fg_focus              = "#FFFFFF"
theme.taglist_bg_focus              = "#CF1B1B"
theme.tasklist_bg_focus             = "#1A1A1A"
theme.tasklist_fg_focus             = "#E5E5E5"
theme.tasklist_fg_normal            = "#7F7F7F"
theme.textbox_widget_margin_top     = 1
theme.notify_fg                     = theme.fg_focus
theme.notify_bg                     = theme.bg_focus
theme.notify_border                 = theme.border_focus
theme.awful_widget_margin_top       = 2
theme.awful_widget_height           = 16
theme.mouse_finder_color            = "#1DD7A4"
theme.menu_height                   = "16"
theme.menu_width                    = "150"
theme.menu_fg_focus                 = "#FFFFFF"
theme.menu_fg_normal                = "#7F7F7F"
theme.menu_bg_normal                = "#1A1A1A"
theme.menu_bg_focus                 = "#ea2828"

theme.submenu_icon                  = themes_dir .. "/icons/submenu.png"
theme.listmenu_icon					= themes_dir .. "/icons/list.png"
theme.taglist_squares_sel           = themes_dir .. "/icons/taglist/squarefza.png"
theme.taglist_squares_unsel         = themes_dir .. "/icons/taglist/squareza.png"

theme.layout_tile                   = themes_dir .. "/icons/layouts/tile.png"
--theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themes_dir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom             = themes_dir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop                = themes_dir .. "/icons/layouts/tiletop.png"
theme.layout_fairv                  = themes_dir .. "/icons/layouts/fairv.png"
theme.layout_fairh                  = themes_dir .. "/icons/layouts/fairh.png"
theme.layout_spiral                 = themes_dir .. "/icons/layouts/spiral.png"
theme.layout_dwindle                = themes_dir .. "/icons/layouts/dwindle.png"
theme.layout_max                    = themes_dir .. "/icons/layouts/max.png"
theme.layout_fullscreen             = themes_dir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier              = themes_dir .. "/icons/layouts/magnifier.png"
theme.layout_floating               = themes_dir .. "/icons/layouts/floating.png"

theme.arrr                          = themes_dir .. "/icons/arrr.png"
theme.arrr_ld                       = themes_dir .. "/icons/r.png"
theme.arrl                          = themes_dir .. "/icons/arrl.png"
theme.arrl_dl                       = themes_dir .. "/icons/arrl_dl.png"
theme.arrl_ld                       = themes_dir .. "/icons/arrl_ld.png"

theme.widget_ac                     = themes_dir .. "/icons/ac.png"
theme.widget_battery                = themes_dir .. "/icons/battery.png"
theme.widget_battery_low            = themes_dir .. "/icons/battery_low.png"
theme.widget_battery_empty          = themes_dir .. "/icons/battery_empty.png"
theme.widget_mem                    = themes_dir .. "/icons/mem.png"
theme.widget_cpu                    = themes_dir .. "/icons/cpu.png"
theme.widget_temp                   = themes_dir .. "/icons/temp.png"
theme.widget_net                    = themes_dir .. "/icons/net.png"
theme.widget_hdd                    = themes_dir .. "/icons/hdd.png"
theme.widget_music                  = themes_dir .. "/icons/note.png"
theme.widget_music_on               = themes_dir .. "/icons/note_on.png"
theme.widget_vol                    = themes_dir .. "/icons/vol.png"
theme.widget_vol_low                = themes_dir .. "/icons/vol_low.png"
theme.widget_vol_no                 = themes_dir .. "/icons/vol_no.png"
theme.widget_vol_mute               = themes_dir .. "/icons/vol_mute.png"
theme.widget_mail                   = themes_dir .. "/icons/mail.png"
theme.widget_mail_on                = themes_dir .. "/icons/mail_on.png"
theme.widget_clock                  = themes_dir .. "/icons/pacman.png"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

theme.awesome_icon = themes_dir .. "/icons/s-logo-20grey.png"
return theme
