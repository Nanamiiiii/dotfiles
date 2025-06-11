-- utils.lua
-- misc plugins

return {
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = vim.opt.sessionoptions:get() },
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>qd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
    {
        'vyfor/cord.nvim',
        build = ':Cord update',
        -- opts = {}
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "lewis6991/gitsigns.nvim",
        config = true,
    },
    { "vim-denops/denops.vim", lazy = true },
    { "lambdalisue/gin.vim", dependencies = "vim-denops/denops.vim" },
    {
        "gamoutatsumi/dps-ghosttext.vim",
        dependencies = "vim-denops/denops.vim",
    },
    {
        "ojroques/nvim-osc52",
        keys = {
            {
                "<leader>c",
                function()
                    require("osc52").copy_operator()
                end,
                expr = true,
            },
            { "<leader>cc", "<leader>c_", remap = true },
            {
                "<leader>c",
                function()
                    require("osc52").copy_visual()
                end,
                mode = "v",
            },
        },
    },
}
