-- plugins/ui.lua

return {
    {
        "akinsho/bufferline.nvim",
        branch = "main",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    indicator = {
                        style = "underline",
                    },
                    offsets = {},
                    separator_style = "slant",
                },
            })

            local opts = { silent = true, noremap = true }
            local keymap = vim.api.nvim_set_keymap
            keymap("n", "<C-n>", ":BufferLineCycleNext<CR>", opts)
            keymap("n", "<C-p>", ":BufferLineCyclePrev<CR>", opts)
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                disabled_filetypes = {
                    "neo-tree",
                },
                theme = "iceberg_dark",
            },
        },
    },
    {
        "petertriho/nvim-scrollbar",
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
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function()
            local unyologo = [[
                ██╗   ██╗███╗   ██╗██╗   ██╗ ██████╗ ██╗   ██╗███╗   ██╗██╗   ██╗ ██████╗                 
                ██║   ██║████╗  ██║╚██╗ ██╔╝██╔═══██╗██║   ██║████╗  ██║╚██╗ ██╔╝██╔═══██╗                
                ██║   ██║██╔██╗ ██║ ╚████╔╝ ██║   ██║██║   ██║██╔██╗ ██║ ╚████╔╝ ██║   ██║                
                ██║   ██║██║╚██╗██║  ╚██╔╝  ██║   ██║██║   ██║██║╚██╗██║  ╚██╔╝  ██║   ██║                
                ╚██████╔╝██║ ╚████║   ██║   ╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ╚██████╔╝                
                 ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    ╚═════╝                 
            ]]

            local normallogo = [[
                ███╗   ██╗██╗   ██╗██╗███╗   ███╗██╗   ██╗██╗   ██╗██╗   ██╗                
                ████╗  ██║██║   ██║██║████╗ ████║╚██╗ ██╔╝██║   ██║██║   ██║                
                ██╔██╗ ██║██║   ██║██║██╔████╔██║ ╚████╔╝ ██║   ██║██║   ██║                
                ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║  ╚██╔╝  ██║   ██║██║   ██║                
                ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ╚██████╔╝╚██████╔╝                
                ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝   ╚═╝    ╚═════╝  ╚═════╝                 
            ]]

            math.randomseed(os.time())
            local logoselect = math.random(5)
            local logo
            if logoselect == 3 then
                logo = string.rep("\n", 8) .. unyologo .. "\n\n"
            else
                logo = string.rep("\n", 8) .. normallogo .. "\n\n"
            end

            local opts = {
                theme = "doom",
                hide = {
                    statusline = false,
                },
                config = {
                    header = vim.split(logo, "\n"),
                    center = {
                        {
                            action = "Telescope find_files",
                            desc = " Find File",
                            icon = " ",
                            key = "f",
                        },
                        {
                            action = "ene | startinsert",
                            desc = " New File",
                            icon = " ",
                            key = "n",
                        },
                        {
                            action = "Telescope oldfiles",
                            desc = " Recent Files",
                            icon = " ",
                            key = "r",
                        },
                        {
                            action = "Telescope live_grep",
                            desc = " Find Text",
                            icon = " ",
                            key = "g",
                        },
                        {
                            action = 'lua require("persistence").load()',
                            desc = " Restore Session",
                            icon = " ",
                            key = "s",
                        },
                        {
                            action = "Lazy",
                            desc = " Plugin Management",
                            icon = "󰒲 ",
                            key = "l",
                        },
                        {
                            action = "qa",
                            desc = " Quit",
                            icon = " ",
                            key = "q",
                        },
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                        return {
                            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
                        }
                    end,
                },
            }

            for _, button in ipairs(opts.config.center) do
                button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
                button.key_format = "  %s"
            end

            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "DashboardLoaded",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            return opts
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },
}
