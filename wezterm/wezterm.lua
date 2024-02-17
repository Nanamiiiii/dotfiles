-- Nanamiiiii's wezterm config

local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- TERM
config.term = 'xterm-256color'

-- Detect OS
local is_macos = wezterm.target_triple:find("darwin")    -- macos
local is_windows = wezterm.target_triple:find("windows") -- windows
local is_linux = wezterm.target_triple:find("linux")     -- linux

-- Detect desktop environment
local de_name = ""
if is_linux then
    de_name = os.getenv("XDG_CURRENT_DESKTOP")
end

-- Default Domain
if is_windows then
    -- config.default_prog = { 'C:\\Program Files\\nu\\bin\\nu.exe' } -- nushell
    -- config.default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe', '-nologo' } -- powershell
    config.default_domain = 'WSL:Arch'
end

-- Size
config.initial_cols = 120
config.initial_rows = 50
config.cell_width = 1.0
config.line_height = 1.0

-- Font
-- Fallback
config.font = wezterm.font_with_fallback {
    'PlemolJP Console',
    'Symbols Nerd Font',
    'PlemolJP Console NF',
    'HackGen Console NF',
    'FirgeConsole Nerd Font',
    'FirgeNerd Console',
    'UDEV Gothic NFLG',
    'SF Pro',
}

-- HackGen
-- config.font = wezterm.font 'HackGen Console NF'

-- Firge Nerd
-- config.font = wezterm.font 'FirgeConsole Nerd Font'
-- config.font = wezterm.font 'FirgeNerd Console'

-- UDEV Gothic
-- config.font = wezterm.font 'UDEV Gothic NFLG'

-- Font Size
if is_macos then
    config.font_size = 18.0
else
    config.font_size = 14.0
end

-- Color Scheme
config.color_scheme = 'iceberg-dark'

-- Opacity
config.window_background_opacity = 0.90
config.text_background_opacity = 0.90
if is_macos then
    config.macos_window_background_blur = 25
elseif is_windows then
    config.window_background_opacity = 0
    config.win32_system_backdrop = 'Tabbed'
end

-- background
--if is_macos then
--    config.window_background_image = "/Users/nanami/.config/wezterm/background.jpg"
--end
config.window_background_image_hsb = {
    brightness = 0.005,
    hue = 1.0,
    saturation = 1.0,
}

-- Hide single tab
config.hide_tab_bar_if_only_one_tab = true

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 20

-- Tab style
function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    return tab_info.active_pane.title
end

-- Title table
local title_map = {}
title_map["zsh"] = {
    title = "Zsh",
    symbol = "󰞷 ",
}
title_map["nu.exe"] = {
    title = "Nu",
    symbol = "󰞷 ",
}
title_map["pwsh.exe"] = {
    title = "Pwsh",
    symbol = "󰞷 ",
}
title_map["nvim.exe"] = {
    title = "nvim",
    symbol = " "
}
title_map["nvim"] = {
    title = "nvim",
    symbol = " "
}
title_map["wslhost.exe"] = {
    title = "WSL",
    symbol = "󰣇 "
}
-- add new mappings here

function title_mapper(title, symbol)
    if title_map[title] ~= nil then
        local items = title_map[title]
        local mapped_title = ""
        if items["symbol"] ~= nil and symbol then
            mapped_title = mapped_title .. items["symbol"]
        end
        if items["title"] ~= nil then
            mapped_title = mapped_title .. items["title"]
        else
            mapped_title = mapped_title .. title
        end
        return mapped_title
    elseif string.match(title, "^.*@.*$") then
        local shell_symbol = ""
        if symbol then
            shell_symbol = "󰞷 "
        end
        return shell_symbol .. title
    else
        return title 
    end
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local title = title_mapper(tab_title(tab), true)
        if tab.is_active then
            return {
                { Text = " " .. title .. " " },
            }
        end
        return " " .. title .. " "
    end
)

-- Window title
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
    local prefix = 'Wezterm'
    local zoomed = ''
    if tab.active_pane.is_zoomed then
        zoomed = '[Z] '
    end

    local index = ''
    if #tabs > 1 then
        index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end

    local title = title_mapper(tab_title(tab), false)

    return prefix .. ' - ' .. zoomed .. index .. title
end)

-- Window setting
if is_macos then
    config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"
elseif is_linux then
    if de_name == "i3" or de_name == "sway" then
        config.window_decorations = "RESIZE"
    else
        config.window_decorations = "TITLE | RESIZE"
        -- config.enable_wayland = false
    end
else -- Windows
    config.window_decorations = "TITLE | RESIZE"
    config.hide_tab_bar_if_only_one_tab = false
end

-- Key bindings
local act = wezterm.action
config.leader = {
    key = "s",
    mods = "CTRL",
    timeout_milliseconds = 1000,
}

config.keys = {
    {
        key = "s",
        mods = "LEADER",
        action = act.SendKey {
            key = "s",
            mods = "CTRL",
        },
    },
    {
        key = "c",
        mods = "LEADER",
        action = act.SpawnTab("CurrentPaneDomain")
    },
    {
        key = "C",
        mods = "LEADER",
        action = act.SpawnWindow
    },
    {
        key = "m",
        mods = "LEADER",
        action = act.ShowLauncher,
    },
    {
        key = "q",
        mods = "LEADER",
        action = act.CloseCurrentTab { confirm = true }
    },
    {
        key = "d",
        mods = "LEADER",
        action = act.DetachDomain("CurrentPaneDomain")
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
        key = "b",
        mods = "LEADER",
        action = act.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        key = "v",
        mods = "LEADER",
        action = act.SplitVertical { domain = "CurrentPaneDomain" }
    },
    {
        key = "x",
        mods = "LEADER",
        action = act.CloseCurrentPane { confirm = true }
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
        action = act.AdjustPaneSize { "Left", 10 }
    },
    {
        key = "L",
        mods = "LEADER",
        action = act.AdjustPaneSize { "Right", 10 }
    },
    {
        key = "K",
        mods = "LEADER",
        action = act.AdjustPaneSize { "Up", 5 }
    },
    {
        key = "J",
        mods = "LEADER",
        action = act.AdjustPaneSize { "Down", 5 }
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
    {
        key = "P",
        mods = "LEADER",
        action = act.ActivateCommandPalette
    }
}

-- WSL
config.wsl_domains = {
    {
        name = 'WSL:Arch',
        distribution = 'Arch',
        default_cwd = '~',
    },
}

-- Windows Launch Menu
---- Select nu, pwsh, cmd, wsl
if is_windows then
    config.launch_menu = {
        {
            label = 'ArchLinux - WSL',
            domain = { DomainName = 'WSL:Arch' },
        },
        {
            label = "Powershell",
            domain = { DomainName = 'local' },
            args = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe', '-nologo' }, 
        },
        {
            label = "Nu",
            domain = { DomainName = 'local' },
            args = { 'C:\\Program Files\\nu\\bin\\nu.exe' },
        },
        {
            label = "CMD",
            domain = { DomainName = 'local' },
            args = { 'C:\\Windows\\System32\\cmd.exe' },
        }
    }
end

return config
