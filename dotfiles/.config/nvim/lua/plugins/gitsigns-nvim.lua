---@module 'lazy'
---@type LazySpec
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gs = require("gitsigns")

            local function with_save(fn)
                return function(...)
                    if vim.bo.modified then
                        vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
                        return
                    end
                    local range
                    if vim.fn.mode():match("[vV\22]") then
                        range = {
                            vim.fn.line("'<"),
                            vim.fn.line("'>"),
                        }
                    end
                    return fn(range, ...)
                end
            end

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
            map("<leader>hr", gs.reset_hunk, "[H]unk [r]eset")
            map("<leader>hR", with_save(gs.reset_buffer), "[R]eset buffer")
            map("<leader>hs", with_save(gs.stage_hunk), "[H]unk [s]tage")
            map("<leader>hS", with_save(gs.stage_buffer), "[S]tage buffer")
        end,
    },
}
