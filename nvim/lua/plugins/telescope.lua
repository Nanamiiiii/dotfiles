-- plugins/telescope.lua

return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").setup()
            local builtin = require("telescope.builtin")
            local opts = { silent = true }
            vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
            vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
        end,
    },
}
