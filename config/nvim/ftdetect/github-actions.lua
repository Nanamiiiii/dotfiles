-- GitHub Actions Filetype
vim.filetype.add({
    pattern = {
        [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
    },
})
