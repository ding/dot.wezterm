-- 20230321 from https://github.com/ivaquero/oxidizer/blob/master/defaults/wezterm.lua
-- 
local wezterm = require("wezterm")

-- local gitbash = {"C:\\Program Files\\Git\\bin\\bash.exe", "-i", "-l"}
local pwsh = {"D:\\scoop\\apps\\pwsh\\current\\pwsh.exe"}
local pwshbeta = {"D:\\scoop\\apps\\pwsh-beta\\current\\pwsh.exe"}
local gitbash = {"D:\\scoop\\apps\\git\\current\\bin\\bash.exe", "-i", "-l"}

-- Title
function basename( s )
    return string.gsub( s, '(.*[/\\])(.*)', '%2' )
end

wezterm.on( 'format-tab-title', function( tab, tabs, panes, config, hover, max_width )
    local pane = tab.active_pane

    local index = ""
    if #tabs > 1 then
        index = string.format( "%d: ", tab.tab_index + 1 )
    end

    local process = basename( pane.foreground_process_name )

    return { {
        Text = ' ' .. index .. process .. ' '
     } }
end )

-- Startup
-- wezterm.on( 'gui-startup', function( cmd )
--     local tab, pane, window = wezterm.mux.spawn_window( cmd or {} )
--     window:gui_window():maximize()
-- end )

local config = {
    -- Basic
    check_for_updates = false,
    switch_to_last_active_tab_when_closing_tab = false,
    enable_scroll_bar = true,

    -- window_background_image = "/path/to/wallpaper.jpg",
    
    color_scheme = "Ollie", -- Batman, OneHalfDark
    default_prog = pwsh,
    -- font = wezterm.font("HackGen35Nerd Console"), -- HackGen35Nerd Console, Firge35Nerd Console
    -- font = wezterm.font("FirgeNerd Console"), -- HackGen35Nerd Console, Firge35Nerd Console
    font = wezterm.font("Firge35Nerd Console"), -- HackGen35Nerd Console, Firge35Nerd Console
    font_size = 12.0,
    use_ime = true, -- 

    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0
     },
    
    -- Window
    native_macos_fullscreen_mode = true,
    adjust_window_size_when_changing_font_size = true,
    window_background_opacity = 1,
    window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
     },
    window_background_image_hsb = {
        brightness = 0.8,
        hue = 1.0,
        saturation = 1.0
     },

    -- Tab Bar
    enable_tab_bar = true,
    adjust_window_size_when_changing_font_size = false,
    -- disable_default_key_bindings = true,
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    -- hide_tab_bar_if_only_one_tab = true,
    show_tab_index_in_tab_bar = false,
    tab_bar_at_bottom = true,
    tab_max_width = 25,

    -- Keys
    disable_default_key_bindings = false,
    leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = {
        {key="l", mods='LEADER', action = wezterm.action.ShowLauncher } ,

        -- Activate the tab navigator UI in the current tab. 
        -- The tab navigator displays a list of tabs and 
        -- allows you to select and activate a tab from that list.
        -- {key="F9", mods='LEADER', action="ShowTabNavigator"},
        -- New/close pane
        { key = 'c', mods = 'LEADER', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } }, 
        { key = 'x', mods = 'LEADER', action = wezterm.action { CloseCurrentPane = { confirm = true } } }, 
        { key = 'X', mods = 'LEADER', action = wezterm.action { CloseCurrentTab = { confirm = true } } },
        -- Pane navigation
        { key = 'LeftArrow', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Left' } }, 
        { key = 'DownArrow', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Down' } }, 
        { key = 'UpArrow', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Up' } }, 
        { key = 'RightArrow', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Right' } }, 
        -- Copy/paste buffer
        -- Active Copy mode
        { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
        -- Copy
        { key = 'y', mods = 'LEADER', action = wezterm.action { CopyTo = 'Clipboard' }}, 
        -- Paste
        { key = 'p', mods = 'LEADER', action = wezterm.action { PasteFrom = 'Clipboard' }}, 
        -- { key = '[', mods = 'LEADER', action = 'ActivateCopyMode' }, 
        { key = ']', mods = 'LEADER', action = 'QuickSelect' } ,

        -- Tab
        { key = 't', mods = 'LEADER', action = 'ShowTabNavigator' }, 
        { key = 'b', mods = 'LEADER', action = 'ActivateLastTab' }, 
        -- { key = '{', mods = 'ALT', action = act.ActivateTabRelative(-1) },
        -- { key = '}', mods = 'ALT', action = act.ActivateTabRelative(1) },
        { key = 'h', mods = 'CTRL', action = wezterm.action { ActivateTabRelative = -1 } }, 
        { key = 'l', mods = 'CTRL', action = wezterm.action { ActivateTabRelative = 1 } },
        { key = 'w', mods = 'CTRL', action = wezterm.action.CloseCurrentTab { confirm = true }, },

        -- Split
        { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } }, 
        { key = '\\', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }}, 
    },

    mouse_bindings = {  -- Paste on right-click
    {
        event = {
            Down = {
                streak = 1,
                button = 'Right'
             }
         },
        mods = 'NONE',
        action = wezterm.action {
            PasteFrom = 'Clipboard'
         }
     }, -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
        event = {
            Up = {
                streak = 1,
                button = 'Left'
             }
         },
        mods = 'NONE',
        action = wezterm.action {
            CompleteSelection = 'PrimarySelection'
         }
     }, -- CTRL-Click open hyperlinks
    {
        event = {
            Up = {
                streak = 1,
                button = 'Left'
             }
         },
        mods = 'CTRL',
        action = 'OpenLinkAtMouseCursor'
     } }, 

    launch_menu = {
        {
            args = {"top"},
        },
        {
            label = "PowerShell",
            args = pwsh,
        },
        {
            label = "pwsh-beta",
            args = pwshbeta,
        },
        {
            label = "Git Bash",
            args = gitbash,
        },
    },
    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = wezterm.truncate_right(utils.basename(tab.active_pane.foreground_process_name), max_width)
	if title == "" then
		title = wezterm.truncate_right(
			utils.basename(utils.convert_home_dir(tab.active_pane.current_working_dir)),
			max_width
		)
	end
	return {
		{ Text = tab.tab_index + 1 .. ":" .. title },
	}
    end),
}

return config

