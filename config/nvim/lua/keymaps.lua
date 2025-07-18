-- keymap.lua
local keymap = vim.api.nvim_set_keymap

-- mapleader
vim.g.mapleader = " "

-- Options
local norm_opt = { noremap = true, silent = true }
local term_opt = { silent = true }
local comp_opt = { noremap = true }

-- Normal mode by jj
keymap("i", "jj", "<ESC>", norm_opt)

-- Window movement
keymap("n", "<C-h>", "<C-w>h", norm_opt)
keymap("n", "<C-j>", "<C-w>j", norm_opt)
keymap("n", "<C-k>", "<C-w>k", norm_opt)
keymap("n", "<C-l>", "<C-w>l", norm_opt)

-- Insert cursor shortcut
keymap("i", "<C-f>", "<C-g>U<Right>", norm_opt) -- go to next pos
keymap("i", "<C-f><C-f>", "<C-g>U<Esc><S-a>", norm_opt) -- go to end of line
