-- plugins/lsp.lua
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local enabled_ls = {
                "lua_ls",
                "rust_analyzer",
                "clangd",
                "cmake",
                "pylsp",
                "gopls",
                "eslint",
                "jsonls",
                "nil_ls",
                "veryl_ls",
                "bashls",
                "taplo",
                "ts_ls",
                "tinymist",
            }

            local attach_callback = function(ctx)
                local opts = { noremap = true, silent = true, buffer = true }
                local set_keymap = vim.keymap.set

                set_keymap("n", "gD", function()
                    vim.lsp.buf.declaration()
                end, opts)
                set_keymap("n", "gd", function()
                    vim.lsp.buf.definition()
                end, opts)
                set_keymap("n", "K", function()
                    vim.lsp.buf.hover()
                end, opts)
                set_keymap("n", "gi", function()
                    vim.lsp.buf.implementation()
                end, opts)
                set_keymap("n", "<C-y>", function()
                    vim.lsp.buf.signature_help()
                end, opts)
                set_keymap("n", "<space>wa", function()
                    vim.lsp.buf.add_workspace_folder()
                end, opts)
                set_keymap("n", "<space>wr", function()
                    vim.lsp.buf.remove_workspace_folder()
                end, opts)
                set_keymap("n", "<space>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                set_keymap("n", "<space>D", function()
                    vim.lsp.buf.type_definition()
                end, opts)
                set_keymap("n", "<space>rn", function()
                    vim.lsp.buf.rename()
                end, opts)
                set_keymap("n", "gr", function()
                    vim.lsp.buf.references()
                end, opts)
                set_keymap("n", "<space>e", function()
                    vim.diagnostic.open_float()
                end, opts)
                set_keymap("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, opts)
                set_keymap("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, opts)
                set_keymap("n", "<space>q", function()
                    vim.lsp.diagnostic.set_loclist()
                end, opts)
                set_keymap("n", "gf", function()
                    vim.lsp.buf.format()
                end, opts)
            end

            local on_attach_func = function(client, bufnr)
                -- Set autocommands conditional on server_capabilities
                if client.server_capabilities.document_highlight then
                    vim.api.nvim_exec(
                        [[
                        :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
                        :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
                        :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
                        augroup lsp_document_highlight
                            autocmd!
                            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                        augroup END
                        ]],
                        false
                    )
                end
            end

            local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = attach_callback,
            })

            vim.lsp.config("*", {
                on_attach = on_attach_func,
                capabilities = cmp_capabilities,
            })

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                },
            })

            vim.lsp.enable(enabled_ls)
        end,
    },
    {
        "nvimdev/lspsaga.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "aznhe21/actions-preview.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            {
                "<leader>ca",
                function()
                    require("actions-preview").code_actions()
                end,
                desc = "Preview Code Actions",
                mode = "n",
            },
        },
    },
}
