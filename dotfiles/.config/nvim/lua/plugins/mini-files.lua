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
    config = function(_, opts)
        require("mini.files").setup(opts)

        -- I like rounded borders
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesWindowOpen",
            callback = function(args)
                local win_id = args.data.win_id

                local config = vim.api.nvim_win_get_config(win_id)
                config.border = "rounded"
                vim.api.nvim_win_set_config(win_id, config)
            end,
        })

        -- Fix background bleeding
        vim.api.nvim_set_hl(0, "MiniFilesNormal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "MiniFilesBorder", { bg = "NONE" })
    end,
}
