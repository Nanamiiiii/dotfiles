-- Nanamiiiii's wezterm config

local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Detect OS
local is_macos = wezterm.target_triple:find("darwin")

-- Size
config.initial_cols = 160
config.initial_rows = 50
config.cell_width = 1.0
config.line_height = 1.0

-- Font
-- Fallback
config.font = wezterm.font_with_fallback {
    'HackGen Console NF',
    'FirgeConsole Nerd Font',
    'FirgeNerd Console',
    'UDEV Gothic NFLG',
}

-- HackGen
-- config.font = wezterm.font 'HackGen Console NF'

-- Firge Nerd
-- config.font = wezterm.font 'FirgeConsole Nerd Font'
-- config.font = wezterm.font 'FirgeNerd Console'

-- UDEV Gothic
-- config.font = wezterm.font 'UDEV Gothic NFLG'

-- Font Size
config.font_size = 18.0

-- Color Scheme
config.color_scheme = 'tokyonight_night'

-- Opacity
config.window_background_opacity = 0.90
config.text_background_opacity = 0.90
if is_macos then
    config.macos_window_background_blur = 25
end

-- background
if is_macos then
    config.window_background_image = "/Users/nanami/.config/wezterm/background.jpg"
end
config.window_background_image_hsb = {
  brightness = 0.005,
  hue = 1.0,
  saturation = 1.0,
}

-- Hide single tab
config.hide_tab_bar_if_only_one_tab = true

-- Tab bar
config.use_fancy_tab_bar = false

-- Key bindings
local act = wezterm.action
config.leader = { 
    key = "s", 
    mods = "CTRL", 
    timeout_milliseconds = 1000, 
}
  
config.keys = {
    { 
        key = "c", 
        mods = "LEADER", 
        action = act.SpawnTab("CurrentPaneDomain") 
    },
    { 
        key = "q", 
        mods = "LEADER", 
        action = act.CloseCurrentTab{ confirm = true } 
    },
    { 
        key = "n", 
        mods = "LEADER", 
        action = act.ActivateTabRelative(1) 
    },
    { 
        key = "p",
        mods = "LEADER", 
        action = act.ActivateTabRelative(-1) 
    },
    {
        key = "w", 
        mods = "LEADER", 
        action = act.ShowTabNavigator 
    },
    
    { 
        key = "v",
        mods = "LEADER", 
        action = act.SplitHorizontal{ domain = "CurrentPaneDomain" } 
    },
    { 
        key = "s",
        mods = "LEADER", 
        action = act.SplitVertical{ domain = "CurrentPaneDomain" } 
    },
    { 
        key = "x", 
        mods = "LEADER",
        action = act.CloseCurrentPane{ confirm = true } 
    },
    { 
        key = "z",
        mods = "LEADER", 
        action = act.TogglePaneZoomState 
    },
    
    { 
        key = "h",
        mods = "LEADER", 
        action = act.ActivatePaneDirection("Left") 
    },
    { 
        key = "l", 
        mods = "LEADER", 
        action = act.ActivatePaneDirection("Right") 
    },
    { 
        key = "k", 
        mods = "LEADER", 
        action = act.ActivatePaneDirection("Up") 
    },
    { 
        key = "j", 
        mods = "LEADER",
        action = act.ActivatePaneDirection("Down") 
    },
    { 
        key = "H", 
        mods = "LEADER", 
        action = act.AdjustPaneSize{"Left", 10} 
    },
    { 
        key = "L", 
        mods = "LEADER", 
        action = act.AdjustPaneSize{"Right", 10} 
    },
    {
        key = "K",
        mods = "LEADER", 
        action = act.AdjustPaneSize{"Up", 5}
    },
    { 
        key = "J", 
        mods = "LEADER", 
        action = act.AdjustPaneSize{"Down", 5} 
    },
    
    { 
        key = "[", 
        mods = "LEADER", 
        action = act.ActivateCopyMode 
    },
    { 
        key = "v", 
        mods = "CTRL|SHIFT", 
        action = act.PasteFrom("Clipboard") 
    },
    
    { 
        key = "Enter", 
        mods = "ALT", 
        action = 'DisableDefaultAssignment' 
    },
}

return config
