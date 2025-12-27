-- options.lua

local options = {
    encoding = "utf-8",
    fileencoding = "utf-8",
    hlsearch = true,
    ignorecase = true,
    smartcase = true,
    autoindent = true,
    number = true,
    relativenumber = true,
    ruler = true,
    wildmenu = true,
    showcmd = true,
    smarttab = true,
    expandtab = true,
    shiftwidth = 4,
    softtabstop = 4,
    tabstop = 4,
    updatetime = 500,
    timeoutlen = 500,
    termguicolors = true,
    pumheight = 15,
    scrolloff = 5,
    conceallevel = 0,
    mouse = "nv",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- wrapping
vim.wo.wrap = false

-- invisible chars
vim.wo.list = true
vim.opt.listchars =
    { tab = "»-", space = "･", trail = "-", eol = "↲", extends = "»", precedes = "«", nbsp = "%" }

-- mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- clipboard
local osc52 = require("vim.ui.clipboard.osc52")
local paste = function()
    return {
        vim.split(vim.fn.getreg(""), "\n"),
        vim.fn.getregtype(""),
    }
end
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
    name = "osc52-write-only",
    copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
    },
    paste = {
        ["+"] = paste,
        ["*"] = paste,
    },
}
