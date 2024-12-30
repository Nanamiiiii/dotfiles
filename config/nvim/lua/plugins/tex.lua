return {
    {
        "lervag/vimtex",
        lazy = true,
        ft = "tex",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "micangl/cmp-vimtex",
        lazy = true,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        ft = "tex",
    },
}
