-- plugins/cmp.lua
return {
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-vsnip",
            "uga-rosa/cmp-skkeleton",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "skkeleton" },
                    { name = "vimtex" },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-l>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                }),
                experimental = {
                    ghost_text = false,
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 80,
                        ellipsis_char = "...",
                        menu = {
                            nvim_lsp = "[LSP]",
                            vsnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                            skkeleton = "[SKK]",
                            vimtex = "[TeX]",
                        },
                    }),
                },
            })
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 80,
                        ellipsis_char = "...",
                        menu = {
                            buffer = "[Buf]",
                        },
                    }),
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "path" },
                    { name = "cmdline" },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 80,
                        ellipsis_char = "...",
                        menu = {
                            path = "[Path]",
                            cmdline = "[CMD]",
                        },
                    }),
                },
            })
        end,
    },
    {
        "hrsh7th/vim-vsnip",
        lazy = false,
        dependencies = {
            "hrsh7th/vim-vsnip-integ",
            "hrsh7th/completion-snippet",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            vim.g.vsnip_snippet_dir = "~/.config/vsnip"
            vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
            vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
            vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
            vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
        end,
    },
}
