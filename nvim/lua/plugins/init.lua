-- plugins/init.lua
-- Simple plugin definition (without complex opts)

return {
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
        'Shougo/deol.nvim',
        keys = {
            { "<C-o>", ":<C-u>Deol -toggle -split=floating<CR>", desc = "deol", silent = true },
            { "<ESC>", [[<C-\><C-n>]], mode = "t", silent = true },
        },
    },
    --'airblade/vim-gitgutter',
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

