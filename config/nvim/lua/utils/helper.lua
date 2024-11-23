-- utils/helper.lua
-- refs: arrow2nd/dotfiles/.config/nvim/lua/util/helper.lua

local helper = {}

-- keymap
for _, mode in pairs({ "n", "v", "i", "o", "c", "t", "t", "x", "s" }) do
    helper[mode .. "map"] = function(lhs, rhs, opts)
        vim.keymap.set(mode, lhs, rhs, opts or { silent = true })
    end
end

-- OS detection
helper["os"] = function()
    return vim.loop.os_uname().sysname
end

return helper
