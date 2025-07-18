-- plugins/lsp.lua
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "clangd",
                    "cmake",
                    "pylsp",
                    "gopls",
                    "ts_ls",
                    "eslint",
                    "jsonls",
                },
                automatic_enable = true,
            })

            vim.lsp.config("*", {
                on_attach = function(client, bufnr)
                    local function buf_set_keymap(...)
                        vim.api.nvim_buf_set_keymap(bufnr, ...)
                    end

                    -- Mappings
                    local opts = { noremap = true, silent = true }
                    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
                    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
                    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
                    buf_set_keymap("n", "<C-y>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
                    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
                    buf_set_keymap(
                        "n",
                        "<space>wl",
                        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                        opts
                    )
                    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
                    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                    buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
                    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.jump({count = -1, float=true})<CR>", opts)
                    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.jump({count = 1, float=true})<CR>", opts)
                    buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
                    buf_set_keymap("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

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
                end,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                handlers = {
                    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                        virtual_text = false,
                    }),
                    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                        border = "rounded",
                    }),
                    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                        border = "rounded",
                    }),
                },
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
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
    },
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require("lspsaga").setup({})
        end,
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
    {
        "ionide/Ionide-vim",
    },
}
