-- Nanamiiiii's neovim config
-- Last Update: 2023.07.08

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

require("options")
require("autocmd")
require("keymaps")
require("lazy_nvim")

-- neovide
require("neovide")

