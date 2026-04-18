---Toggle explorer
---
---@param path string|nil
---@param use_latest boolean|nil
---@param opts table|nil
local toggle_minifiles = function(path, use_latest, opts)
    local MiniFiles = require("mini.files")
    if not MiniFiles.close() then
        MiniFiles.open(path, use_latest, opts)
    end
end

---@module 'lazy'
---@type LazySpec
return {
    "nvim-mini/mini.files",
    dependencies = { "nvim-mini/mini.icons" },
    keys = {
        {
            "\\",
            toggle_minifiles,
            desc = "File explorer",
        },
        {
            "<leader>e",
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                local path = vim.fn.fnamemodify(bufname, ":p")
                path = path or nil
                toggle_minifiles(path)
            end,
            desc = "File explorer in current buf directory",
        },
    },
    opts = {
        options = {
            use_as_default_explorer = true,
        },
        windows = {
            max_number = 4,
        },
        mappings = {
            show_help = "?",

            -- navigation
            go_in = "l",
            go_in_plus = "<cr>",
            go_out = "h",
            go_out_plus = "<tab>",
            reset = "<BS>",

            -- file ops (these were missing 👇)
            mark_set = "m",
            mark_all = "M",
            mark_none = "<C-q>",
            cut = "x",
            copy = "y",
            paste = "p",

            -- misc
            reveal_cwd = "@",
            synchronize = "=",
            trim_left = "<",
            trim_right = ">",
        },
    },
}
