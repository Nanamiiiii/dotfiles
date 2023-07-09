-- plugins/filer.lua
-- filer plugin: NeoTree

local deps = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {
        's1n7ax/nvim-window-picker',
        version = "1.*",
        config = function()
            require('window-picker').setup({
                autoselect_one = true,
                include_current = false,
                filter_rules = {
                    bo = {
                        filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                        buftype = { 'terminal', "quickfix" },
                    },
                },
                other_win_hl_color = '#e35e4f',
            })
        end,
    },
}

local setup = function()
    require('neo-tree').setup {
        filesystem = {
            filtered_items = {
                visible = true, 
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false, 
                hide_by_name = {
                    "node_modules"
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
                    "thumbs.db"
                },
                never_show_by_pattern = { 
                    ".null-ls_*",
                },
            },
            follow_current_file = false, 
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
                }
            }
        },
        buffers = {
            follow_current_file = true, 
            group_empty_dirs = true, 
            show_unloaded = true,
            window = {
                mappings = {
                    ["bd"] = "buffer_delete",
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                }
            }
        }
    }
end

return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        version = "2.*",
        dependencies = deps,
        keys = {
            { "<C-t>", ":Neotree toggle<CR>", desc = "NeoTree", silent = true },
        },
        config = setup,
    }
}
