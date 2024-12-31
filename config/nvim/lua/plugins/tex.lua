local h = require("utils.helper")

local viewApp = h.os() == "Darwin" and "skim" or "general"

return {
    {
        "lervag/vimtex",
        lazy = true,
        ft = { "tex", "latex" },
        event = { "BufReadPre", "BufNewFile" },
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_view_method = viewApp
            vim.g.vimtex_compiler_latexmk = {
                out_dir = "out",
                continuous = 1,
            }
            vim.g.vimtex_quickfix_open_on_warning = 0
        end,
    },
    {
        "micangl/cmp-vimtex",
        lazy = true,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        ft = { "tex", "latex" },
        event = { "BufReadPre", "BufNewFile" },
    },
}
