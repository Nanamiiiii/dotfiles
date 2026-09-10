-- markdown.lua
local h = require("utils.helper")
return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        cond = not h.in_obsidian_vault(),
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
}
