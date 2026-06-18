-- plugins/treesitter.lua

return {
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        config = function()
            require("tree-sitter-manager").setup({
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
                    "nix",
                },
                auto_install = true,
            })
        end,
    },
    {
        "RRethy/nvim-treesitter-endwise",
        config = function()
            require("nvim-treesitter-endwise").init()
        end,
    },
    {
        "andymass/vim-matchup",
        init = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
            vim.g.matchup_treesitter_enable_quotes = true
            vim.g.matchup_treesitter_disable_virtual_text = true
            vim.g.matchup_treesitter_include_match_words = true
        end,
    },
}
