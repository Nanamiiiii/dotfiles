-- plugins/treesitter.lua

return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = "BufRead",
        cmd = {
            "TSUpdate",
            "TSInstall"
        },
        init = function ()
              
        end,
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
                sync_install = true,
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
