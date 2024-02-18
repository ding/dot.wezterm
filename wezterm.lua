-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

local haswork,work = pcall(require,"work")

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- x86_64-pc-windows-msvc - Windows
-- x86_64-apple-darwin - macOS (Intel)
-- aarch64-apple-darwin - macOS (Apple Silicon)
-- x86_64-unknown-linux-gnu - Linux

if string.match(wezterm.target_triple, '.*windows.*') ~= nil then
  --- Grab the ver info for later use.
  local success, stdout, stderr = wezterm.run_child_process { 'cmd.exe', 'ver' }
  local major, minor, build, rev = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
  local is_windows_11 = tonumber(build) >= 22000
  
  --- Make it look cool.
  if is_windows_11 then
    wezterm.log_info "We're running Windows 11!"
  else
    wezterm.log_info "We're running OLD Windows !!"
  end

  local pwsh = {"D:\\scoop\\apps\\pwsh\\current\\pwsh.exe"}
  local pwshbeta = {"D:\\scoop\\apps\\pwsh-beta\\current\\pwsh.exe"}
  local gitbash = {"D:\\scoop\\apps\\git\\current\\bin\\bash.exe", "-i", "-l"}
  local default_prog = {'wsl.exe', '~', '-d', 'Ubuntu-20.04'}
  -- local default_font = "Firge35Nerd Console" -- HackGen35Nerd Console, Firge35Nerd Console
  config.font = wezterm.font_with_fallback {
  { family = 'Moralerspace Krypton' },
  { family = 'Firge35Nerd Console' },
  { family = 'HackGen35Nerd Console' },
  { family = 'Hack Nerd Font', } }
  config.default_prog = pwsh
  config.launch_menu = {
      { args = {"top"}, },
      { label = "PowerShell", args = pwsh, },
      { label = "pwsh-beta", args = pwshbeta, },
      { label = "Git Bash", args = gitbash, }, }

elseif string.match(wezterm.target_triple, '.*apple.*') ~= nil then
  wezterm.log_info "We're running Apple OS !!"

  -- Configs for OSX only
  -- font_dirs    = { '$HOME/.dotfiles/.fonts' }
  config.font = wezterm.font_with_fallback {
  { family = 'Monaco' },
  { family = 'Firge35Nerd Console' },
  { family = 'HackGen35Nerd Console' },}

elseif string.match(wezterm.target_triple, '.*linux.*') ~= nil then
  wezterm.log_info "We're running Linux !!"
  -- if wezterm.target_triple == 'x86_65-unknown-linux-gnu' then
  -- Configs for Linux only
  -- font_dirs    = { '$HOME/.dotfiles/.fonts' }
  config.font = wezterm.font_with_fallback {
  { family = 'Firge35Nerd Console' },
  { family = 'HackGen35Nerd Console' },
  { family = 'Monaco', } }

else
  wezterm.log_info "We're running Unknown OS ... !!"
  config.font = wezterm.font_with_fallback {
  { family = 'Firge35Nerd Console' },
  { family = 'HackGen35Nerd Console' },
  { family = 'Monaco', } }
end

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
end)

--- Default config settings 
config.check_for_updates = false
config.switch_to_last_active_tab_when_closing_tab = false
config.enable_scroll_bar = true

-- window_background_image = "/path/to/wallpaper.jpg",
    
-- config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte, "Ollie", -- Batman, OneHalfDark
config.color_scheme = "Frappe" -- or Macchiato, Frappe, Latte, "Ollie", -- Batman, OneHalfDark
config.font_size = 11.0
config.use_ime = true
config.inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0
     }
    
-- Window
config.adjust_window_size_when_changing_font_size = true
config.window_background_opacity = 1
config.window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
     }
config.window_background_image_hsb = {
        brightness = 0.8,
        hue = 1.0,
        saturation = 1.0
     }

-- Tab Bar
config.enable_tab_bar = true
config.adjust_window_size_when_changing_font_size = false
-- disable_default_key_bindings = true,
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
-- hide_tab_bar_if_only_one_tab = true,
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25

-- Keys
config.disable_default_key_bindings = false
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
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

    -- CTRL-SHIFT-l activates the debug overlay
    { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
    }

config.mouse_bindings = {  -- Paste on right-click
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
     } } 



-- Allow overwriting for work stuff
if haswork then
  work.apply_to_config(config)
end
return config

