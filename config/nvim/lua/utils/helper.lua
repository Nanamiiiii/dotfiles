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
    local check = io.popen("command -v " .. cmd)
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

-- Detect SSH Connection
helper["is_ssh"] = function()
    return os.getenv("SSH_CLIENT") ~= nil or os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CONNECTION") ~= nil
end

return helper
