return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    cond = function()
        local obsidian_dir = ".obsidian"
        local stat = vim.loop.fs_stat(vim.fn.getcwd() .. "/" .. obsidian_dir)
        if stat and stat.type == "directory" then
            return true
        else
            return false
        end
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        legacy_commands = false,
        workspaces = {
            {
                name = "Nanami Lab",
                path = "~/Documents/Nanami Lab",
            },
        },
        preferred_link_style = "wiki",
        daily_notes = {
            folder = "Daily Notes",
            date_format = "%Y-%m-%d",
            alias_format = "%B %-d, %Y",
            default_tags = { "Daily" },
            template = "DailyNotesVim.md",
        },
        ---@return string
        image_name_func = function()
            return string.format("attached_image_%s.png", os.time())
        end,
        attachments = {
            folder = "_assets",
            ---@param client obsidian.Client
            ---@param path obsidian.Path the absolute path to the image file
            ---@return string
            img_text_func = function(client, path)
                path = client:vault_relative_path(path) or path
                return string.format("![[%s]]", path.name)
            end,
            confirm_img_paste = false,
        },
        templates = {
            folder = "_config/VimTemplate",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M:%S",
            substitutions = {
                ---@return string
                yesterday = function()
                    return tostring(os.date("%Y-%m-%d", os.time() - 86400))
                end,
                ---@return string
                before_week = function()
                    return tostring(os.date("%Y-%m-%d", os.time() - (86400 * 7)))
                end,
                ---@return string
                tomorrow = function()
                    return tostring(os.date("%Y-%m-%d", os.time() + 86400))
                end,
                ---@return string
                after_week = function()
                    return tostring(os.date("%Y-%m-%d", os.time() + (86400 * 7)))
                end,
                ---@return string
                full_datetime = function()
                    local time, _ = tostring(os.date("%Y-%m-%dT%H:%M:%S%z")):gsub("(%d%d)$", ":%1")
                    return time
                end,
            },
        },
        frontmatter = {
            enabled = true,
            ---@return table
            func = function(note)
                local out = { id = note.id, aliases = note.aliases, tags = note.tags }

                -- Set title
                out.title = note.id

                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end

                -- Set created/updated time
                local curtime, _ = tostring(os.date("%Y-%m-%dT%H:%M:%S%z")):gsub("(%d%d)$", ":%1")
                if out["created"] == nil then
                    out["created"] = curtime
                end
                out["updated"] = curtime

                return out
            end,
            sort = { "id", "title", "aliases", "tags" },
        },
    },
    init = function()
        vim.o.conceallevel = 2
    end,
}
