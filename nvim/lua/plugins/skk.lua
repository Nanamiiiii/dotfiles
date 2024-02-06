-- plugins/skk.lua

local h = require("utils.helper")

return {
    {
        'vim-skk/skkeleton',
        lazy = false,
        dependencies = { 
            'vim-denops/denops.vim',
            {
                'delphinus/skkeleton_indicator.nvim',
                config = function ()
                    vim.api.nvim_set_hl(0, "SkkeletonIndicatorEiji",
                      { fg = "#82c9f5", bg = "#1d2840", bold = true })
                    vim.api.nvim_set_hl(0, "SkkeletonIndicatorHira",
                      { fg = "#1d2840", bg = "#82c9f5", bold = true })
                    require("skkeleton_indicator").setup({
                        eijiText = "en",
                        hiraText = "hira",
                        kataText = "kana",
                        hankataText = "h-kana",
                        zenkakuText = "z-en",
                    })
                end,
            },
        },
        init = function ()
            -- keymap
            h.imap("<C-j>", "<Plug>(skkeleton-enable)")
            h.cmap("<C-j>", "<Plug>(skkeleton-enable)")
            -- dictionary
            local dictionaries = {}
            local skk_dir = h.os() == "Windows_NT" and "C:\\skkeleton\\" or "~/.skkeleton/"
            local list_cmd = h.os() == "Windows_NT" and "dir /s /b /a-d " .. skk_dir .. "dict" or "/bin/ls -d -p " .. skk_dir .. "dict/* | grep -vE /$"
            local handle = io.popen(list_cmd)
            if handle then
                for path in handle:lines() do
                    table.insert(dictionaries, path)
                end
            end
            handle:close()

            vim.api.nvim_create_autocmd("User", {
                pattern = "skkeleton-initialize-pre",
                callback = function ()
                    vim.fn["skkeleton#config"]({
                        eggLikeNewline = true,
                        registerConvertResult = true,
                        completionRankFile = skk_dir .. "rank.json",
                        globalDictionaries = dictionaries,
                        sources = {"skk_dictionary"},
                        userDictionary = skk_dir .. "userdict.txt",
                        --useSkkServer = true,
                    })
                end,
            })
        end,
    }
}

