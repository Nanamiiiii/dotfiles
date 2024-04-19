-- options.lua

local options = {
    encoding = "utf-8",
    fileencoding = "utf-8",
    clipboard = "unnamedplus",
    hlsearch = true,
    ignorecase = true,
    smartcase = true,
    autoindent = true,
    number = true,
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
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- wrapping
vim.wo.wrap = false

-- invisible chars
vim.wo.list = true
vim.opt.listchars = {tab='»-', space='･', trail='-', eol='↲', extends='»', precedes='«', nbsp='%'}

vim.g.mapleader = " "
