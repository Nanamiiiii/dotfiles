-- plugins/skk.lua

local h = require("utils.helper")

return {
    {
        'vim-skk/skkeleton',
        lazy = false,
        dependencies = { 
            'vim-denops/denops.vim',
            'delphinus/skkeleton_indicator.nvim',
        },
        init = function ()
            -- keymap
            h.imap("<C-j>", "<Plug>(skkeleton-enable)")
            h.cmap("<C-j>", "<Plug>(skkeleton-enable)")
            -- dictionary
            local dictionaries = {}
            local skk_dir = h.os == "Windows" and [[C:\skkeleton\]] or "~/.skkeleton/"
            local handle = h.os == "Windows" and io.popen([[dir /s /b /a-d]] .. skk_dir .. "dict") or io.popen("ls -d -p " .. skk_dir .. "dict/* | grep -vE /$")
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
                        userJisyo = skk_dir .. "userdict.txt",
                        --useSkkServer = true,
                    })
                end,
            })
        end,
    }
}

