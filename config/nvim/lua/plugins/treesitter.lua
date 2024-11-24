-- plugins/treesitter.lua

return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
        build = ":TSUpdate",
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        cmd = {
            "TSUpdateSync",
            "TSUpdate",
            "TSInstall",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
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
                    "bash",
                    "diff",
                    "html",
                    "javascript",
                    "jsdoc",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "query",
                    "regex",
                    "toml",
                    "tsx",
                    "typescript",
                    "xml",
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
            })
        end,
    },
}
