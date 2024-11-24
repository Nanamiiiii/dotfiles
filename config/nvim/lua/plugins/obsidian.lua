return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "Documents/Nanami Lab/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "Documents/Nanami Lab/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
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
        attachments = {
            img_folder = "_assets",
            ---@return string
            img_name_func = function()
                return string.format("Pasted_%s_", os.time())
            end,
            ---@param client obsidian.Client
            ---@param path obsidian.Path the absolute path to the image file
            ---@return string
            img_text_func = function(client, path)
                path = client:vault_relative_path(path) or path
                return string.format("![[%s]]", path.name)
            end,
        },
        templates = {
            folder = "_config/Template",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M:%S",
            substitutions = {
                ---@return string
                yesterday = function()
                    return os.date("%Y-%m-%d", os.time() - 86400)
                end,
                ---@return string
                before_week = function()
                    return os.date("%Y-%m-%d", os.time() - (86400 * 7))
                end,
                ---@return string
                tomorrow = function()
                    return os.date("%Y-%m-%d", os.time() + 86400)
                end,
                ---@return string
                after_week = function()
                    return os.date("%Y-%m-%d", os.time() + (86400 * 7))
                end,
                ---@return string
                full_datetime = function()
                    return os.date("%Y-%m-%dT%H:%M:%S+09:00")
                end,
            },
        },
        ---@return table
        note_frontmatter_func = function(note)
            if note.title then
                note:add_alias(note.title)
            end

            local out = { id = note.id, aliases = note.aliases, tags = note.tags }

            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                for k, v in pairs(note.metadata) do
                    out[k] = v
                end
            end

            return out
        end,
    },
}
