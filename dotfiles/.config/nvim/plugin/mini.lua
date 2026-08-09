local gh = require('utils.pack').gh

local mini_specs = {
    {
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
    },
    {
        'nvim-mini/mini.icons',
        opts = { style = 'glyph' },
    },
    { "nvim-mini/mini.ai" },
    {
        "nvim-mini/mini.surround",
        opts = {
            ---@module 'mini.surround'
            mappings = {
                add = "<leader>sa",
                delete = "<leader>sd",
                find = "<leader>sf", -- Find surrounding (to the right)
                find_left = "<leader>sF", -- Find surrounding (to the left)
                highlight = "<leader>sh", -- Highlight surrounding
                replace = "<leader>sr", -- Replace surrounding
              -- suffix_last = 'l', -- Suffix to search with "prev" method
              -- suffix_next = 'n', -- Suffix to search with "next" method
            },
            search_method = "cover_or_next",
        },
    }
}

vim.pack.add(vim.tbl_map(function (spec)
    return { src = gh(spec[1]) }
end, mini_specs))

for _, spec in ipairs(mini_specs) do
    local opts = spec.opts or {}
    local name = spec[1]:match("([^/]+)$")
    require(name).setup(opts)
end

