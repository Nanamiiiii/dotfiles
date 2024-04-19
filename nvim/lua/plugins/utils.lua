-- utils.lua
-- misc plugins

return {
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = vim.opt.sessionoptions:get() },
        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
        },
    },
    {
        'Nanamiiiii/vimsence',
        config = function()
            vim.g.vimsence_small_text = 'neovim'
            vim.g.vimsence_small_image = 'neovim'
            vim.g.vimsence_editing_details = 'Editing: {}'
            vim.g.vimsence_editing_state = 'Working on: {}'
            vim.g.vimsence_explorer_text = 'in Filer'
            vim.g.vimsence_explorer_details = 'Exploring files'
        end,
    },
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    {
        'lewis6991/gitsigns.nvim',
        config = true,
    },
    { 'vim-denops/denops.vim', lazy = true },
    { 'lambdalisue/gin.vim', dependencies = 'vim-denops/denops.vim' },
    {
        'gamoutatsumi/dps-ghosttext.vim',
        dependencies = 'vim-denops/denops.vim',
    },
}
