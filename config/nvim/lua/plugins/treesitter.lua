-- plugins/treesitter.lua

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function()
            local treesitter = require("nvim-treesitter")

            treesitter.setup({
                install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "/nvim-treesitter"),
            })

            local ok, err = pcall(function()
                local enabled_list = {
                    "bash",
                    "c",
                    "cpp",
                    "diff",
                    "dockerfile",
                    "cmake",
                    "git_config",
                    "gitattribute",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "html",
                    "json",
                    "javascript",
                    "jsdoc",
                    "lua",
                    "luadoc",
                    "luap",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "nix",
                    "python",
                    "query",
                    "regex",
                    "rust",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "xml",
                    "yaml",
                }

                local installed = treesitter.get_installed()
                local missing = vim.tbl_filter(function(lang)
                    return not vim.tbl_contains(installed, lang)
                end, enabled_list)

                treesitter.install(missing)
            end)

            if not ok then
                vim.notify(
                    err or "failed to install required parsers",
                    vim.log.levels.ERROR,
                    { title = "nvim-treesitter" }
                )
            end
        end,
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            local augroup = vim.api.nvim_create_augroup("myuu.plugins.nvim-treesitter.init", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = augroup,
                callback = function(ctx)
                    local filetype = ctx.match
                    local treesitter = require("nvim-treesitter")
                    local ok = pcall(vim.treesitter.start, ctx.buf)
                    if ok then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(filetype)
                    local available = treesitter.get_available()
                    if not vim.tbl_contains(available, lang) then
                        return
                    end

                    treesitter.install({ lang }):await(function(err)
                        if err then
                            vim.notify(err, vim.log.levels.ERROR, { title = "nvim-treesitter" })
                        end
                        pcall(vim.treesitter.start, ctx.buf)
                    end)
                end,
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
