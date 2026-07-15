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
            ---@param func function|string
            ---@param desc string
            ---@param mode string|string[]|nil
            local function map(keys, func, desc, mode)
                mode = mode or { "n", "v", "x" }
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
            map("<leader>hr", ":Gitsigns reset_hunk<cr>", "[H]unk [r]eset")
            map("<leader>hR", gs.reset_buffer, "[R]eset buffer")
            map("<leader>hs", ":Gitsigns stage_hunk<cr>", "[H]unk [s]tage")
            map("<leader>hS", gs.stage_buffer, "[S]tage buffer")
        end,
    },
}
