-- plugins/filer.lua
-- filer plugin: NeoTree

local deps = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                autoselect_one = true,
                include_current = false,
                filter_rules = {
                    bo = {
                        filetype = { "neo-tree", "neo-tree-popup", "notify" },
                        buftype = { "terminal", "quickfix" },
                    },
                },
                other_win_hl_color = "#e35e4f",
            })
        end,
    },
}

local opts = {
    sources = {
        "filesystem",
        "buffers",
        "git_status",
    },
    source_selector = {
        winbar = false, -- toggle to show selector on winbar
        statusline = true, -- toggle to show selector on statusline
        show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
        -- of the top visible node when scrolled down.
        sources = {
            { source = "filesystem", display_name = " File" },
            { source = "buffers", display_name = " Buf" },
            { source = "git_status", display_name = " Git" },
        },
        content_layout = "center", -- only with `tabs_layout` = "equal", "focus"
        tabs_layout = "equal", -- start, end, center, equal, focus
        truncation_character = "…", -- character to use when truncating the tab label
        tabs_min_width = nil, -- nil | int: if int padding is added based on `content_layout`
        tabs_max_width = nil, -- this will truncate text even if `text_trunc_to_fit = false`
        padding = 0, -- can be int or table
        separator = { left = "▏", right = "▕" },
        separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
        show_separator_on_edge = false,
        highlight_tab = "NeoTreeTabInactive",
        highlight_tab_active = "NeoTreeTabActive",
        highlight_background = "NeoTreeTabInactive",
        highlight_separator = "NeoTreeTabSeparatorInactive",
        highlight_separator_active = "NeoTreeTabSeparatorActive",
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
            hide_by_name = {
                "node_modules",
            },
            hide_by_pattern = {
                --"*.meta",
                --"*/src/*/tsconfig.json",
            },
            always_show = {
                ".gitignored",
            },
            never_show = {
                ".DS_Store",
                "thumbs.db",
            },
            never_show_by_pattern = {
                ".null-ls_*",
            },
        },
        follow_current_file = {
            enabled = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = false,
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["D"] = "fuzzy_finder_directory",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
            },
        },
    },
    buffers = {
        follow_current_file = {
            enabled = true,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
            },
        },
    },
    window = {
        position = "float",
    },
    popup_border_style = "rounded",
}

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        version = "3.*",
        dependencies = deps,
        keys = {
            { "<leader>ft", "<CMD>Neotree toggle<CR>", desc = "NeoTree", silent = true },
            { "<leader>bf", "<CMD>Neotree toggle source=buffers<CR>", desc = "NeoTree Buffers", silent = true },
            { "<leader>gt", "<CMD>Neotree toggle source=git_status<CR>", desc = "NeoTree Git", silent = true },
        },
        opts = opts,
        config = true,
    },
}
