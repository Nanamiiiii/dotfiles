return {
    settings = {
        ['nil'] = {
            formatting = {
                command = { "nixfmt" },
            },
            nix = {
                flake = {
                    autoArchive = true,
                },
            },
        },
    },
}
