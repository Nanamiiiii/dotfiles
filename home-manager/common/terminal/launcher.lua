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
            label = "ranger",
            args = { "@ranger_bin@" },
            cwd = "~/",
        },
        {
            label = "btop",
            args = { "@btop_bin@" },
        },
        {
            label = "spotify",
            args = { "@spotify_player_bin@" },
        },
    }
}
