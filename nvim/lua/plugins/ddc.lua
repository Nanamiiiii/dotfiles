-- plugins/ddc.lua

return {
    {
        'Shougo/ddc.vim',
        lazy = false,
        dependencies = {
            "vim-denops/denops.vim",
            --"Shougo/pum.vim",
            --"Shougo/ddc-ui-pum",
            "Shougo/ddc-ui-native",
            "Shougo/ddc-source-around",
            "Shougo/ddc-source-nvim-lsp",
            "LumaKernel/ddc-source-file",
            "uga-rosa/ddc-source-vsnip",
            "Shougo/ddc-source-cmdline",
            "Shougo/ddc-source-cmdline-history",
            "Shougo/ddc-filter-matcher_head",
            "Shougo/ddc-filter-sorter_rank",
            "Shougo/ddc-filter-converter_truncate_abbr",
            "Shougo/ddc-filter-converter_remove_overlap",
            "matsui54/denops-popup-preview.vim",
            "matsui54/denops-signature_help",
        },
        config = function()
            local patch_global = vim.fn['ddc#custom#patch_global']
            patch_global("ui", "native")
            --patch_global("ui", "pum")
            patch_global("sources", {
                'around',
                'nvim-lsp',
                'vsnip',
                'file',
                'cmdline',
                'cmdline-history',
            })
            patch_global("sourceOptions", {
                _ = {
                    matchers = { "matcher_head" },
                    sorters = { "sorter_rank" },
                    converters = { "converter_truncate_abbr", "converter_remove_overlap" },
                    ignoreCase = true,
                },
                around = {
                    mark = "[ar]",
                },
                ["nvim-lsp"] = {
                    mark = "[lsp]",
                    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
                },
                file = {
                    mark = "[file]",
                    isVolatile = true,
                    forceCompletionPattern = [[\S/\S*]],
                },
                cmdline = {
                    mark = "[cmd]"
                },
                ["cmdline-history"] = {
                    mark = "[cmd-h]"
                }
            })
            patch_global("autoCompleteEvents", {
                "InsertEnter",
                "TextChansgedI",
                "TextChangedP",
                "CmdlineEnter",
                "CmdlineChanged",
            })

            vim.cmd([[inoremap <silent><expr> <TAB> ddc#map#pum_visible() ? '<C-n>' : (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ? '<TAB>' : ddc#map#manual_complete()]])
            vim.cmd([[inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>']])

            vim.fn['ddc#enable']()
        end,
    },
    --{
    --    'Shougo/pum.vim',
    --    keys = {
    --        { "<C-n>", ":call pum#map#select_relative(+1)<CR>", mode = "i" },
    --        { "<C-p>", ":call pum#map#select_relative(-1)<CR>", mode = "i" },
    --        { "<C-y>", ":call pum#map#confirm()<CR>", mode = "i" },
    --        { "<C-q>", ":call pum#map#cancel()<CR>", mode = "i" },
    --        { "<Tab>", ":call pum#map#insert_relative(+1)<CR>", mode = "c" },
    --        { "<S-Tab>", ":call pum#map#insert_relative(-1)<CR>", mode = "c" },
    --    },
    --    config = function()
    --        vim.fn['pum#set_option']({
    --            use_complete = true,
    --            border = "rounded",
    --            auto_select = true,
    --            padding = true,
    --            scrollbar_char = "",
    --        })
    --    end,
    --},
    {
        "matsui54/denops-popup-preview.vim",
        dependencies = { "vim-denops/denops.vim" },
        config = function()
            vim.g.popup_preview_config = {
                border = false,
                supportVsnip = true,
                supportUltisnips = false,
                supportInfo = true,
                delay = 60,
            }
            vim.fn["popup_preview#enable"]()
        end,
    },
    {
        "matsui54/denops-signature_help",
        dependencies = { "vim-denops/denops.vim" },
        config = function()
            vim.g.signature_help_config = {
                contentsStyle = "currentLabel",
                viewStyle = "virtual",
            }
            vim.fn["signature_help#enable"]()
        end,
    },
    {
        "hrsh7th/vim-vsnip",
        lazy = false,
        dependencies = { "hrsh7th/vim-vsnip-integ", "rafamadriz/friendly-snippets" },
        config = function()
            vim.g.vsnip_snippet_dir = "~/.config/vsnip"
            vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
            vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
            vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
            vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
        end,
    },
}
