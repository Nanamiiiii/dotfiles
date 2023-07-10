-- plugins/ui.lua

return {
    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup {
                options = {
                    indicator = {
                        style = 'underline',
                    },
                    offsets = {},
                    separator_style = 'slant'
                }
            }

            local opts = { silent = true, noremap = true }
            local keymap = vim.api.nvim_set_keymap
            keymap("n", "<C-n>", ":BufferLineCycleNext<CR>", opts)
            keymap("n", "<C-p>", ":BufferLineCyclePrev<CR>", opts)
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                disabled_filetypes = {
                    'neo-tree',
                },
                theme = 'iceberg_dark',
            }
        },
    },
    {
        'petertriho/nvim-scrollbar',
        event = {
            "BufWinEnter",
            "CmdwinLeave",
            "TabEnter",
            "TermEnter",
            "TextChanged",
            "VimResized",
            "WinEnter",
            "WinScrolled",
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
}

