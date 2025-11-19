-- Nanamiiiii's wezterm config

local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- TERM
config.term = "xterm-256color"

-- IME
config.use_ime = false

-- Detect OS
local is_macos = wezterm.target_triple:find("darwin") -- macos
local is_windows = wezterm.target_triple:find("windows") -- windows
local is_linux = wezterm.target_triple:find("linux") -- linux

-- Default Shell
if is_windows then
    config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-nologo" }
end

-- Hostname
local hostname = ""
if is_linux then
    local handle = io.popen("uname -n")
    if handle ~= nil then
        hostname = string.gsub(handle:read("a"), "[\n\r]", "")
        handle:close()
    end
end

-- Graphics
config.enable_wayland = true
config.front_end = "OpenGL"
if hostname == "mafu" or hostname == "nacho" then
    config.front_end = "WebGpu"
end

-- Detect desktop environment
local de_name = ""
local wm_name = ""
if is_linux then
    de_name = os.getenv("XDG_CURRENT_DESKTOP") or ""
elseif is_macos then
    de_name = "aqua"
    local handle = io.popen('/bin/ps -e | grep -o -e "[y]abai" | uniq')
    if handle ~= nil then
        local result = string.gsub(handle:read("a"), "[\n\r]", "")
        handle:close()
        if result == "yabai" then
            wm_name = "yabai"
        else
            wm_name = "quartz"
        end
    end
end

-- Size
config.initial_cols = 120
config.initial_rows = 50
config.cell_width = 1.0
config.line_height = 1.0

-- Font
config.font = wezterm.font_with_fallback({
    "PlemolJP Console",
    "Symbols Nerd Font",
    "PlemolJP Console NF",
    "HackGen Console NF",
    "FirgeConsole Nerd Font",
    "FirgeNerd Console",
    "UDEV Gothic NFLG",
    "Noto Sans Symbols",
    "Noto Sans Symbols 2",
    "SF Pro",
})

-- Font Size
if is_macos then
    config.font_size = 16.0
elseif hostname == "xanadu" then
    config.font_size = 12.5
elseif hostname == "yuki" then
    config.font_size = 13
else
    config.font_size = 14.0
end

-- Color Scheme
config.color_scheme = "tokyonight"
-- config.color_scheme = "iceberg-dark"
-- config.color_scheme = "Tokyo Night Moon"

-- Opacity
if is_macos then
    config.macos_window_background_blur = 25
    config.window_background_opacity = 0.90
else
    config.window_background_opacity = 0.90
    config.text_background_opacity = 0.90
    if is_windows then
        config.window_background_opacity = 0
        config.win32_system_backdrop = "Mica"
    end
end

-- background
config.window_background_image_hsb = {
    brightness = 0.005,
    hue = 1.0,
    saturation = 1.0,
}

-- Tab Settings
config.tab_max_width = 20

if is_windows then
    config.use_fancy_tab_bar = true
    config.tab_bar_at_bottom = false
    config.hide_tab_bar_if_only_one_tab = false
else
    config.use_fancy_tab_bar = false
    config.tab_bar_at_bottom = true
    config.hide_tab_bar_if_only_one_tab = true
end

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
    title = "neovim",
    symbol = " ",
}
title_map["nvim"] = {
    title = "neovim",
    symbol = " ",
}
title_map["wslhost.exe"] = {
    title = "WSL",
    symbol = "󰣇 ",
}
title_map["wsl.exe"] = {
    title = "WSL",
    symbol = "󰣇 ",
}
title_map["tmux"] = {
    title = "tmux",
    symbol = " ",
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

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = title_mapper(tab_title(tab), true)
    if tab.is_active then
        return {
            { Text = " " .. title .. " " },
        }
    end
    return " " .. title .. " "
end)

-- Window title
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
    local prefix = "Wezterm"
    local zoomed = ""
    if tab.active_pane.is_zoomed then
        zoomed = "[Z] "
    end

    local index = ""
    if #tabs > 1 then
        index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
    end

    local title = title_mapper(tab_title(tab), false)

    return prefix .. " - " .. zoomed .. index .. title
end)

-- Maximize
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

-- Window setting
if is_macos then
    config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"
elseif is_linux then
    if de_name == "i3" or de_name == "sway" or de_name == "Hyprland" then
        config.window_decorations = "NONE"
    else
        config.window_decorations = "TITLE | RESIZE"
    end
else -- Windows
    config.window_decorations = "TITLE | RESIZE"
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
        action = act.SendKey({
            key = "s",
            mods = "CTRL",
        }),
    },
    {
        key = "c",
        mods = "LEADER",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "C",
        mods = "LEADER",
        action = act.SpawnWindow,
    },
    {
        key = "m",
        mods = "LEADER",
        action = act.ShowLauncherArgs({ flags = "FUZZY | LAUNCH_MENU_ITEMS | DOMAINS", title = "Launcher" }),
    },
    {
        key = "W",
        mods = "LEADER",
        action = act.ShowLauncherArgs({ flags = "FUZZY | WORKSPACES", title = "Workspaces Switcher" }),
    },
    {
        key = "N",
        mods = "LEADER",
        action = act.PromptInputLine({
            description = "New workspace:",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace({
                            name = line,
                        }),
                        pane
                    )
                end
            end),
        }),
    },
    {
        key = "q",
        mods = "LEADER",
        action = act.CloseCurrentTab({ confirm = true }),
    },
    {
        key = "d",
        mods = "LEADER",
        action = act.DetachDomain("CurrentPaneDomain"),
    },
    {
        key = "n",
        mods = "LEADER",
        action = act.ActivateTabRelative(1),
    },
    {
        key = "p",
        mods = "LEADER",
        action = act.ActivateTabRelative(-1),
    },
    {
        key = "w",
        mods = "LEADER",
        action = act.ShowTabNavigator,
    },
    {
        key = "b",
        mods = "LEADER",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "v",
        mods = "LEADER",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "x",
        mods = "LEADER",
        action = act.CloseCurrentPane({ confirm = true }),
    },
    {
        key = "z",
        mods = "LEADER",
        action = act.TogglePaneZoomState,
    },

    {
        key = "h",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "l",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Right"),
    },
    {
        key = "k",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "j",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "H",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Left", 10 }),
    },
    {
        key = "L",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Right", 10 }),
    },
    {
        key = "K",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Up", 5 }),
    },
    {
        key = "J",
        mods = "LEADER",
        action = act.AdjustPaneSize({ "Down", 5 }),
    },

    {
        key = "[",
        mods = "LEADER",
        action = act.ActivateCopyMode,
    },
    {
        key = "v",
        mods = "CTRL|SHIFT",
        action = act.PasteFrom("Clipboard"),
    },
    {
        key = "Enter",
        mods = "ALT",
        action = "DisableDefaultAssignment",
    },
    {
        key = "P",
        mods = "LEADER",
        action = act.ActivateCommandPalette,
    },
}

-- WSL
if is_windows then
    local wsl_dist = wezterm.default_wsl_domains()
    for idx, dom in ipairs(wsl_dist) do
        dom.default_cwd = "~"
    end
    config.wsl_domains = wsl_dist
else
    config.unix_domains = {
        {
            name = "wezmux",
        },
    }
end

-- Linux Launch Menu
if is_linux then
    config.launch_menu = {
        {
            label = "zsh",
            args = { "zsh", "-l" },
        },
        {
            label = "bash",
            args = { "bash", "-l" },
        },
        {
            label = "nvim",
            args = { "nvim" },
            cwd = "~/",
        },
        {
            label = "ranger",
            args = { "ranger" },
            cwd = "~/",
        },
        {
            label = "btop",
            args = { "btop" },
        },
        {
            label = "spotify",
            args = { "spotify_player" },
        },
    }

    config.serial_ports = {
        {
            name = "USB Serial 1",
            port = "/dev/ttyUSB0",
            baud = 115200,
        },
        {
            name = "USB Serial 2",
            port = "/dev/ttyUSB1",
            baud = 115200,
        },
    }
end

-- macOS Launch Menu
if is_macos then
    config.launch_menu = {
        {
            label = "zsh",
            args = { "zsh", "-l" },
        },
        {
            label = "bash",
            args = { "bash", "-l" },
        },
        {
            label = "nvim",
            args = { "nvim" },
            cwd = "~/",
        },
        {
            label = "ranger",
            args = { "ranger" },
            cwd = "~/",
        },
        {
            label = "btop",
            args = { "btop" },
        },
        {
            label = "spotify",
            args = { "spotify_player" },
        },
    }
end

-- Windows Launch Menu
if is_windows then
    -- pwsh & cmd
    config.launch_menu = {
        {
            label = "Powershell",
            domain = { DomainName = "local" },
            args = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-nologo" },
        },
        {
            label = "Command Prompt",
            domain = { DomainName = "local" },
            args = { "C:\\Windows\\System32\\cmd.exe" },
        },
    }
    -- wezterm ssh does not work correctly on windows
    -- create launcher entry directly executing ssh.exe from ssh domain
    local ssh_domains = wezterm.default_ssh_domains()
    local ssh_executable = "C:\\Windows\\System32\\OpenSSH\\ssh.exe"
    for idx, dom in ipairs(ssh_domains) do
        if dom.multiplexing == "None" then -- ignore SSHMUX domain
            table.insert(config.launch_menu, {
                label = dom.name,
                domain = { DomainName = "local" },
                args = {
                    ssh_executable,
                    dom.remote_address,
                },
            })
        end
    end
end

-- Fix for BrokenPipe on Wayland w/ NVIDIA
--if hostname == "mafu" then
--    config.enable_wayland = false
--end

-- SSH Agent
local SSH_AUTH_SOCK = os.getenv("SSH_AUTH_SOCK")
local gpg_ssh_sock = string.format("%s/gnupg/S.gpg-agent.ssh", os.getenv("XDG_RUNTIME_DIR"))
local gpg_ssh_sock_alt = string.format("%s/.gnupg/S.gpg-agent.ssh", os.getenv("HOME"))
if SSH_AUTH_SOCK ~= gpg_ssh_sock and SSH_AUTH_SOCK ~= gpg_ssh_sock_alt then
    if #wezterm.glob(gpg_ssh_sock) == 1 then
        config.default_ssh_auth_sock = gpg_ssh_sock
    elseif #wezterm.glob(gpg_ssh_sock_alt) == 1 then
        config.default_ssh_auth_sock = gpg_ssh_sock_alt
    end
end

return config
