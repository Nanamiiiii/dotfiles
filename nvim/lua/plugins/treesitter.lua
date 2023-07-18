-- plugins/treesitter.lua

return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = false,
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        cmd = {
            "TSUpdateSync",
        },
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    "c",
                    "rust",
                    "go",
                    "lua",
                    "python",
                    "cpp",
                    "yaml",
                    "json",
                    "bash",
                    "dockerfile",
                    "vim",
                    "vimdoc",
                    "make",
                    "cmake",
                },
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
