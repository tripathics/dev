local gh = require('utils.pack').gh

local themes = {
    { "rose-pine/neovim", name = "rose-pine" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "EdenEast/nightfox.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "neanias/everforest-nvim" },
}

vim.pack.add (vim.tbl_map(function (theme)
    return {
        src = gh(theme[1]),
        name = theme.name,
    }
end, themes))

-- configure everforest
require("everforest").setup{
    background = "hard",
    italics = true,
    on_highlights = function(hl, palette)
        hl.LspReferenceText = { bg = palette.bg1 }
        hl.LspReferenceRead = { bg = palette.bg1 }
        hl.LspReferenceWrite = { bg = palette.bg1, underline = true }

        -- nvim-treesitter/nvim-treesitter-context
        hl.TreesitterContext = { bg = palette.bg2 }
        hl.TreesitterContextBottom = { bg = palette.bg2, underline = true, sp = palette.grey0 }

        -- diagnostics
        hl.DiagnosticUnderlineHint = { undercurl = true, sp = palette.purple, fg = palette.none }
    end,
}
vim.cmd.colorscheme("everforest")
