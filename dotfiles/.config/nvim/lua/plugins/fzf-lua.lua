-- Picker

---@module 'Lazy'
---@type LazySpec
return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        local fzf_lua = require("fzf-lua")
        fzf_lua.setup({
            files = {
                previewer = false,
            },
            oldfiles = {
                previewer = false,
            },
            grep = {
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
            },
            lines = {
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
            },

            lsp = {
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
                code_actions = {
                    previewer = false,
                },
            },
        }, true)

        fzf_lua.register_ui_select()

        ---@param keys string
        ---@param func function|string
        ---@param desc string
        ---@param mode string|string[]|nil
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { desc = desc })
        end

        map("<leader><space>", fzf_lua.buffers, "Find Buffers")
        map("<leader>ff", fzf_lua.files, "Find Files")
        map("<leader>fn", function()
            fzf_lua.files({ cwd = vim.fn.stdpath("config") })
        end, "Find Files")
        map("<leader>fg", fzf_lua.git_status, "[F]zfLua [G]it status")
        map("<leader>fs", fzf_lua.live_grep, "[F]zfLua Live Grep [S]earch")
        map("<leader>f.", fzf_lua.oldfiles, "[F]zfLua Old files")
        map("<leader>/", fzf_lua.lines, "Search Lines")
        map("<leader>fp", fzf_lua.builtin, "[F]zfLua builtins")
    end,
}
