-- autocmd.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local ft = require("filetypes")

augroup("rc", {})

-- auto ft detection
autocmd({ "FileReadPost", "BufAdd", "BufEnter", "BufNew", "BufNewFile", "BufRead" }, {
    group = "rc",
    pattern = {"*"},
    command = "filetype detect",
})

-- ft specific settings
autocmd("Filetype", {
    group = "rc",
    pattern = "*",
    callback = function(args) ft[args.match]() end,
})
