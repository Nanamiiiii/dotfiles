-- autocmd.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local ft = require("filetypes")

local augroup_rc = augroup("myuu.rc", {})
-- auto ft detection
--autocmd({ "FileReadPost", "BufAdd", "BufEnter", "BufNew", "BufNewFile", "BufRead" }, {
--    group = "rc",
--    pattern = "*",
--    command = "filetype detect",
--})

-- ft specific settings
autocmd("Filetype", {
    group = augroup_rc,
    pattern = "*",
    callback = function(args)
        ft[args.match]()
    end,
})

-- Lazy.nvim auto update check
local augroup_lazy = augroup("myuu.lazynvim_autoupd", { clear = true })
autocmd("VimEnter", {
    group = augroup_lazy,
    callback = function()
        if require("lazy.status").has_updates then
            require("lazy").update({ show = false })
        end
    end,
})
