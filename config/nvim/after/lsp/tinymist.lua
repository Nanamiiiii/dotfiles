return {
    settings = {
        exportPdf = "onSave",
        outputPath = "$root/out/$dir/$name",
        preview = {
            refresh = "onType",
            scrollSync = "onSelectionChange",
            cursorIndicator = true,
            partialRendering = true,
            browsing = {
                args = {
                    "--data-plane-host=127.0.0.1:0",
                    "--invert-colors=never",
                    "--open",
                },
            },
        },
    },

    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "TinymistPreview", function()
            client:exec_cmd({
                command = "tinymist.startDefaultPreview",
                arguments = {},
            }, {
                bufnr = bufnr,
            })
        end, {
            desc = "Start Tinymist builtin preview",
        })
    end,
}
