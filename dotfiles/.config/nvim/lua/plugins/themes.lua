---@module 'lazy'
---@type LazySpec[]
return {
    {
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
        "folke/tokyonight.nvim",
        opts = {
            style = "storm",
            transparent = true,
            styles = {
                comments = { italic = false }, -- Disable italics in comments
                sidebars = "transparent",
                float = "transparent",
            },
        },
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "rebelot/kanagawa.nvim" },
    {
        "neanias/everforest-nvim",
        config = function()
            ---@module 'everforest'
            ---@type Everforest.Config
            ---@diagnostic disable:missing-fields
            local opts = {
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
            require("everforest").setup(opts)

            vim.cmd.colorscheme("everforest")
        end,
    },
}
