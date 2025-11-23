-- plugins/lsp.lua
local lsp_configuration = function() end

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
            }

            local attach_callback = function(ctx)
                local opts = { noremap = true, silent = true, buffer = true }
                local set_keymap = vim.keymap.set

                set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
                set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
                set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
                set_keymap("n", "<C-y>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
                set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
                set_keymap(
                    "n",
                    "<space>wl",
                    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                    opts
                )
                set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
                set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
                set_keymap("n", "[d", "<cmd>lua vim.diagnostic.jump({count = -1, float=true})<CR>", opts)
                set_keymap("n", "]d", "<cmd>lua vim.diagnostic.jump({count = 1, float=true})<CR>", opts)
                set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
                set_keymap("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
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

            local lsp_handlers = {
                ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = false,
                }),
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                    border = "rounded",
                }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                    border = "rounded",
                }),
            }

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = attach_callback,
            })

            vim.lsp.config("*", {
                on_attach = on_attach_func,
                capabilities = cmp_capabilities,
                handlers = lsp_handlers,
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
