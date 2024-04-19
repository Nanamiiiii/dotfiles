-- terminal.lua
-- terminal plugin

return {
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
    }
} 

