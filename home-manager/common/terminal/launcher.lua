return {
    menu = {
        {
            label = "zsh",
            args = { "@zsh_bin@", "-l" },
        },
        {
            label = "zellij",
            args = { "@zellij_bin@", "a", "--create", "main" },
        },
        {
            label = "neovim",
            args = { "@neovim_bin@" },
            cwd = "~/",
        },
        {
            label = "btop",
            args = { "@btop_bin@" },
        },
    }
}
