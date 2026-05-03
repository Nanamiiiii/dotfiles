local flake_path = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')
local nixos_profile = "";
--local home_profile = ""

vim.lsp.config("nixd", {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', '.git' },
    settings = {
        nixd = {
            nixpkgs = {
                expr = string.format('import (builtins.getFlake "%s").inputs.nixpkgs { }', flake_path),
            },
            formatting = {
                command = { 'nixfmt' },
            },
            options = {
                nixos = {
                    expr = string.format('(builtins.getFlake "%s").nixosConfigurations.%s.options', flake_path,
                        nixos_profile),
                },
                ['home-manager'] = {
                    expr = string.format(
                        '(builtins.getFlake "%s").nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []',
                        flake_path, nixos_profile),
                },
                --['home-manager'] = {
                --    expr = string.format(
                --        '(builtins.getFlake "%s").homeConfigurations.%s.options',
                --        flake_path, home_profile),
                --},
            },
        },
    }
})
vim.lsp.enable("nixd")

local capability_group = vim.api.nvim_create_augroup('nix-lsp-coexist', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
    group = capability_group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= 'nixd' then return end

        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.documentSymbolProvider = false
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.renameProvider = false
        client.server_capabilities.codeActionProvider = false
        client.server_capabilities.signatureHelpProvider = nil
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

local original_handler = vim.lsp.handlers['textDocument/publishDiagnostics']
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client and client.name == 'nixd' then
        return
    end
    return original_handler(err, result, ctx, config)
end
