-- plugins/init.lua
-- Simple plugin definition (without complex opts)

return {
    { "folke/lazy.nvim", version = "*" },
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
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            direction = 'float',
        },
        keys = {
            { "<C-o>", ':ToggleTerm<CR>', desc = "toggleterm", mode = "n", silent = true },
            { "<C-o>", '<C-\\><C-n>:ToggleTerm<CR>', desc = "toggleterm", mode = "t", silent = true },
        },
    },
}

