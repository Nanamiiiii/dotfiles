-- Nanamiiiii's neovim config
require("options")
require("keymaps")
require("lazy-init")
require("autocmd")

-- neovide
if vim.g.neovide then
    require("neovide")
end
