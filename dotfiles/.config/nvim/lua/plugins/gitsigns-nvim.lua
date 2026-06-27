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
            local nmap = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { desc = "GitSigns: " .. desc, buf = bufnr })
            end

            nmap("[c", function() gs.nav_hunk("prev") end, "Prev git change")
            nmap("]c", function() gs.nav_hunk("next") end, "Next git change")

            -- blame
            nmap("<leader>ht", gs.toggle_current_line_blame, "[T]oggle current line blame")
            nmap("<leader>hb", gs.blame_line, "[B]lame line")
            nmap("<leader>hB", gs.blame, "[B]lame")

            -- hunks and buffers
            nmap("<leader>hp", gs.preview_hunk, "[H]unk [p]review")
            nmap("<leader>hr", gs.reset_hunk, "[H]unk [r]eset")
            nmap("<leader>hR", gs.reset_buffer, "[R]eset buffer")
            nmap("<leader>hs", gs.stage_hunk, "[H]unk [s]tage")
            nmap("<leader>hS", gs.stage_buffer, "[S]tage buffer")
            nmap("<leader>hd", gs.diffthis, "[D]iff against index")
            nmap("<leader>hD", function()
                gs.diffthis("~1")
            end, "[D]iff against last commit")
        end,
    },
}
