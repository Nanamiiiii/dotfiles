local h = require("utils.helper")

local viewApp = {
    Darwin = "skim",
    Linux = "zathura",
    Windows_NT = "general",
}

return {
    {
        "lervag/vimtex",
        lazy = true,
        ft = { "tex", "latex" },
        event = { "BufReadPre", "BufNewFile" },
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_view_method = viewApp[h.os()]
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
