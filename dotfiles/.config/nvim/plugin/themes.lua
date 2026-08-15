local add = require('utils.pack').add

add ({
    { src = 'rose-pine/neovim', name = 'rose-pine' },
    { src = 'catppuccin/nvim', name = 'catppuccin' },
    { src = 'EdenEast/nightfox.nvim' },
    { src = 'rebelot/kanagawa.nvim', config = function()
        vim.cmd.colorscheme 'kanagawa-dragon'
    end},
    {
        src = 'neanias/everforest-nvim',
        config = function()
            require('everforest').setup {
                background = 'hard',
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
            -- vim.cmd.colorscheme 'everforest'
        end,
    },
}, true)
