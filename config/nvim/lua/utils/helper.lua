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

-- Get binary path
helper["binary_path"] = function(cmd)
    local check = io.popen("which " .. cmd)
    if check ~= nil then
        local check_out = check:read("*a")
        local code = check:close()
        if code == true then
            return string.gsub(check_out, "\n$", "")
        else
            return nil
        end
    else
        return nil
    end
end

return helper
