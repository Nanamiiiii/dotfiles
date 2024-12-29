-- filetypes.lua

local M = {}

-- indent setting
local set_indent = function(tab_size, expand)
    vim.bo.expandtab = expand
    vim.bo.shiftwidth = tab_size
    vim.bo.softtabstop = tab_size
    vim.bo.tabstop = tab_size
end

-- ft specific settings
-- yaml
M.yaml = function()
    set_indent(2, true)
end

-- makefile
M.make = function()
    set_indent(4, false)
end

-- markdown
M.markdown = function()
    set_indent(4, true)
    vim.opt_local.conceallevel = 1
end

-- nix
M.nix = function()
    set_indent(2, true)
end

return setmetatable(M, {
    __index = function()
        return function()
            -- default setting
            set_indent(4, true)
        end
    end,
})
