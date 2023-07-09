-- plugins/treesitter.lua

return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = "BufRead",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "c", "rust", "go", "lua", "python" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                endwise = {
                    enable = true,
                },
            }
        end,
    },
}
