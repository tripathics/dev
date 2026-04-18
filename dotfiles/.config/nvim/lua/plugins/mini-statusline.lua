---@module 'lazy'
---@type LazySpec
return {
    "nvim-mini/mini.statusline",
    opts = {
        content = {
            active = function()
                local statusline = require("mini.statusline")
                local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
                local git = statusline.section_git({ trunc_width = 75 })
                local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
                local filename = statusline.section_filename({ trunc_width = 140 })
                local location = "%2l:%-2v"
                local search = statusline.section_searchcount({ trunc_width = 75 })

                return statusline.combine_groups({
                    { hl = mode_hl, strings = { mode } },
                    { hl = "MiniStatuslineDevinfo", strings = { git } },
                    "%<", -- Mark general truncate point
                    { hl = "MiniStatuslineFilename", strings = { filename } },
                    "%=", -- End left alignment
                    { hl = "MiniStatuslineFileinfo", strings = { diagnostics } },
                    { hl = mode_hl, strings = { search, location } },
                })
            end,
        },
        use_icons = vim.g.have_nerd_font,
    },
}
