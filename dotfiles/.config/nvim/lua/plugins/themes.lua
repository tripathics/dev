---@module 'lazy'
---@type LazySpec[]
return {
    { "folke/tokyonight.nvim", lazy = true },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
    },
    { "EdenEast/nightfox.nvim", lazy = true },
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },
    {
        "neanias/everforest-nvim",
        ---@module 'everforest'
        ---@type Everforest.Config
        ---@diagnostic disable:missing-fields
        opts = {
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
        },
        config = function(_, opts)
            require("everforest").setup(opts)
            vim.cmd.colorscheme("everforest")
        end,
    },
}
