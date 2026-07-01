---@module 'lazy'
---@type LazySpec
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gs = require("gitsigns")

            ---Map keys for working with hunks
            ---@param keys string
            ---@param func function
            ---@param desc string
            ---@param mode string|string[]|nil
            local map = function(keys, func, desc, mode)
                mode = mode or { "n", "v" }
                vim.keymap.set(mode, keys, func, { desc = "GitSigns: " .. desc, buf = bufnr })
            end

            map("[c", function() gs.nav_hunk("prev") end, "Prev git change")
            map("]c", function() gs.nav_hunk("next") end, "Next git change")

            -- blame
            map("<leader>ht", gs.toggle_current_line_blame, "[T]oggle current line blame")
            map("<leader>hb", gs.blame_line, "[B]lame line")
            map("<leader>hB", gs.blame, "[B]lame")

            -- hunks
            map("<leader>hp", gs.preview_hunk, "[H]unk [p]review")
            map("<leader>hr", gs.reset_hunk, "[H]unk [r]eset")
            map("<leader>hR", gs.reset_buffer, "[R]eset buffer")
            map("<leader>hs", gs.stage_hunk, "[H]unk [s]tage")
            map("<leader>hS", gs.stage_buffer, "[S]tage buffer")
        end,
    },
}
