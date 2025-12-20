-- plugins/colorscheme.lua

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "auto",
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = true,
                float = {
                    transparent = true,
                },
                neotree = true,
                noice = true,
                notify = true,
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
