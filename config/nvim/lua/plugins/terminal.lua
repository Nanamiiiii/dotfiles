-- terminal.lua
-- terminal plugin

return {
    {
        "folke/snacks.nvim",
        opts = { terminal = {} },
        keys = {
            {
                "<leader>tf",
                function()
                    require("utils.terminal").toggle()
                end,
                desc = "Open floating terminal",
                mode = "n",
                silent = true,
            },
            {
                "<leader>tt",
                function()
                    require("utils.terminal").toggle("tab")
                end,
                desc = "Open tab terminal",
                mode = "n",
                silent = true,
            },
            {
                "<leader>tv",
                function()
                    require("utils.terminal").toggle("vertical")
                end,
                desc = "Open vertical terminal",
                mode = "n",
                silent = true,
            },
            {
                "<leader>th",
                function()
                    require("utils.terminal").toggle("horizontal")
                end,
                desc = "Open horizontal terminal",
                mode = "n",
                silent = true,
            },
            {
                "<C-o>",
                "<C-\\><C-n>",
                desc = "Exit Terminal Mode",
                mode = "t",
                silent = true,
            },
        },
    },
}
