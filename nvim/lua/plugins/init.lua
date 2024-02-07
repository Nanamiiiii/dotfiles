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
    --{
    --    'Shougo/deol.nvim',
    --    keys = {
    --        { "<C-o>", ":<C-u>Deol -toggle -split=floating<CR>", desc = "deol", silent = true },
    --        { "<ESC>", [[<C-\><C-n>]], mode = "t", silent = true },
    --    },
    --},
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
    {
        'numToStr/FTerm.nvim',
        opts = {
            ft = 'FTerm',
            cmd = os.getenv('SHELL'),
            border = 'single',
            auto_close = true,
            hl = 'Normal',
            blend = 0,
            dimensions = {
                height = 0.8,
                width = 0.8,
                x = 0.5,
                y = 0.5,
            },
            clear_env = false,
            env = nil,
            on_exit = nil,
            on_stdout = nil,
            on_stderr = nil,
        },
        keys = {
            { "<C-o>", '<CMD>lua require("FTerm").toggle()<CR>', desc = "fterm", mode = "n", silent = true },
            { "<C-o>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', desc = "fterm", mode = "t", silent = true },
        },
    }
}

