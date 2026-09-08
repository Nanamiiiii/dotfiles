-- Keep shell identity independent of cwd and presentation. Claude Code owns its
-- own Snacks terminals and must not participate in this toggle group.
local M = {}
local api = vim.api
local terminals, saved_view = {}, { 1 }
local sizes = {}

local function highlights()
    local bg = api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    local shaded
    if bg then
        local r, g, b = math.floor(bg / 65536), math.floor(bg / 256) % 256, bg % 256
        local bright = (0.299 * r + 0.587 * g + 0.114 * b) / 255 > 0.5
        local factor = bright and 1.9 or 0.7
        local function shade(channel)
            return math.min(255, math.floor(channel * factor))
        end
        shaded = string.format("#%02x%02x%02x", shade(r), shade(g), shade(b))
    end
    api.nvim_set_hl(0, "ShellTerminal", { bg = shaded })
end
highlights()
api.nvim_create_autocmd("ColorScheme", {
    group = api.nvim_create_augroup("shell_terminal_colors", { clear = true }),
    callback = highlights,
})

local function remember(term)
    if not term.win:win_valid() then
        return
    end
    if term.direction == "vertical" then
        sizes.vertical = api.nvim_win_get_width(term.win.win)
    elseif term.direction == "horizontal" then
        sizes.horizontal = api.nvim_win_get_height(term.win.win)
    end
end

local function hide(term)
    remember(term)
    local focused = term.win.win == api.nvim_get_current_win()
    local insert = term.insert
    term.win:hide()
    term.insert = insert
    if focused and term.origin and api.nvim_win_is_valid(term.origin) then
        api.nvim_set_current_win(term.origin)
    end
end

local function geometry(direction)
    if direction == "tab" then
        return { position = "current", width = 0, height = 0, border = "none" }
    elseif direction == "vertical" then
        return {
            position = "right",
            width = sizes.vertical or math.floor(vim.o.columns * 0.4),
            height = 0,
            border = "none",
        }
    elseif direction == "horizontal" then
        return {
            position = "bottom",
            height = sizes.horizontal or math.floor(vim.o.lines * 0.4),
            width = 0,
            border = "none",
        }
    end
    local width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 20)))
    local height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))
    return {
        position = "float",
        width = width,
        height = height,
        row = math.ceil(vim.o.lines - height) * 0.5 - 1,
        col = math.ceil(vim.o.columns - width) * 0.5 - 1,
        border = "single",
    }
end

local function show(id, direction)
    local term = terminals[id]
    if term and not term.win:buf_valid() then
        terminals[id], term = nil, nil
    end
    term = term or { direction = "float", insert = true }
    terminals[id] = term
    term.direction = direction or term.direction
    term.origin = api.nvim_get_current_win()
    if term.direction == "tab" then
        vim.cmd.tabnew()
    end
    local opts = geometry(term.direction)
    if term.win then
        term.win.opts = vim.tbl_deep_extend("force", term.win.opts, opts)
        term.win:show()
    else
        opts = vim.tbl_deep_extend("force", opts, {
            backdrop = false,
            keys = { q = false, gf = false, term_normal = false },
            wo = {
                winbar = "",
                number = false,
                relativenumber = false,
                signcolumn = "no",
                winhighlight = "Normal:ShellTerminal,NormalFloat:ShellTerminal,SignColumn:ShellTerminal,EndOfBuffer:ShellTerminal,FloatBorder:Normal",
            },
            on_close = function()
                remember(term)
            end,
        })
        term.win = require("snacks").terminal.open(nil, {
            count = id,
            cwd = vim.fn.getcwd(),
            interactive = false,
            win = opts,
        })
        local buf = term.win.buf
        -- Buffer events survive window hiding and recreation.
        api.nvim_create_autocmd({ "TermEnter", "TermLeave" }, {
            buffer = buf,
            callback = function(event)
                term.insert = event.event == "TermEnter"
            end,
        })
        api.nvim_create_autocmd("BufLeave", {
            buffer = buf,
            callback = function()
                local insert = api.nvim_get_mode().mode == "t"
                vim.schedule(function()
                    if term.win:win_valid() and api.nvim_get_current_buf() ~= buf then
                        term.insert = insert
                        if term.direction == "float" then
                            hide(term)
                        end
                    end
                end)
            end,
        })
        api.nvim_create_autocmd("BufEnter", {
            buffer = buf,
            callback = function()
                vim.schedule(function()
                    if api.nvim_get_current_buf() == buf then
                        if term.insert then
                            vim.cmd.startinsert()
                        else
                            vim.cmd.stopinsert()
                        end
                    end
                end)
            end,
        })
        api.nvim_create_autocmd("TermClose", {
            buffer = buf,
            once = true,
            callback = function()
                vim.schedule(function()
                    if term.win:buf_valid() then
                        hide(term)
                        term.win:close()
                    end
                    terminals[id] = nil
                end)
            end,
        })
    end
    term.win:focus()
    if term.insert then
        vim.cmd.startinsert()
    else
        vim.cmd.stopinsert()
    end
end

function M.toggle(direction, count)
    count = count or vim.v.count
    if count > 0 then
        local term = terminals[count]
        if term and term.win:win_valid() then
            hide(term)
        else
            show(count, direction)
        end
        saved_view = { count }
        return
    end
    local visible = {}
    for id, term in pairs(terminals) do
        if term.win:win_valid() then
            visible[#visible + 1] = id
        end
    end
    table.sort(visible)
    if #visible > 0 then
        saved_view = visible
        for _, id in ipairs(visible) do
            hide(terminals[id])
        end
    else
        for _, id in ipairs(saved_view) do
            show(id, direction)
        end
    end
end

return M
