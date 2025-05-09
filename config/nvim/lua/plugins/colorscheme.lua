-- plugins/colorscheme.lua

return {
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyobones")
            vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" }) -- fix for neo-tree's mismatched border
            -- For invisible chars
            vim.api.nvim_set_hl(0, "NonText", { fg = "#2f3145" })
            vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#2f3145" })
        end,
    },
}
