-- options.lua
local h = require("utils.helper")

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
    clipboard = "unnamedplus",
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

local provider = nil

local paste = {
    ["+"] = nil,
    ["*"] = nil,
}

local paste_unnamed = function()
    return {
        vim.split(vim.fn.getreg(""), "\n"),
        vim.fn.getregtype(""),
    }
end

if not h.is_ssh() then
    if vim.fn.executable("pbpaste") == 1 then
        paste["+"] = { "pbpaste" }
        paste["*"] = { "pbpaste" }
        provider = "osc52-copy-pbpaste"
    elseif vim.fn.executable("wl-paste") == 1 then
        paste["+"] = { "wl-paste", "--no-newline" }
        paste["*"] = { "wl-paste", "--no-newline", "--primary" }
        provider = "osc52-copy-wl-paste"
    elseif vim.fn.executable("waypaste") == 1 then
        paste["+"] = { "waypaste" }
        paste["*"] = { "waypaste", "-p" }
        provider = "osc52-copy-waypaste"
    elseif vim.fn.executable("xclip") == 1 then
        paste["+"] = { "xclip", "-o", "-selection", "clipboard" }
        paste["*"] = { "xclip", "-o", "-selection", "primary" }
        provider = "osc52-copy-xclip"
    elseif vim.fn.executable("xsel") == 1 then
        paste["+"] = { "xsel", "-o", "-b" }
        paste["*"] = { "xsel", "-o", "-p" }
        provider = "osc52-copy-xsel"
    end
else
    paste["+"] = paste_unnamed
    paste["*"] = paste_unnamed
    provider = "osc52-copy-internal-paste"
end

vim.g.clipboard = {
    name = provider,
    copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
    },
    paste = {
        ["+"] = paste["+"],
        ["*"] = paste["*"],
    },
}
