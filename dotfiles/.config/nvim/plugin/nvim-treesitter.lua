local gh = require('utils.pack').gh

local specs = {
    {
        'tripathics/nvim-treesitter',
        config = function ()
            local ts = require('nvim-treesitter')
            ts.setup { prefer_git = true }
            ts.install {
                "angular",
                "bash",
                "c",
                "cpp",
                "fish",
                "gitcommit",
                "go",
                "graphql",
                "html",
                "hyprlang",
                "java",
                "javascript",
                "json",
                "json5",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "rasi",
                "regex",
                "rust",
                "scss",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            }
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function ()
            local ts_context = require('treesitter-context')
            ts_context.setup {
                enable = true,
                -- Avoid the sticky context from growing a lot.
                max_lines = 3,
                -- Match the context lines to the source code.
                multiline_threshold = 1,
                -- Disable it when the window is too small.
                min_window_height = 20,
                -- line_numbers = true,
                trim_scope = "inner",
            }

            ---@param lhs string
            ---@param rhs string|function
            ---@param desc string|nil
            ---@param mode string|nil
            local function map(lhs, rhs, desc, mode)
                mode = mode or 'n'
                vim.keymap.set(mode, lhs, rhs, { desc = desc })
            end

            map('[n', function()
                vim.schedule(function()
                    ts_context.go_to_context()
                end)
            end, "Jump to upper context")

            map('<leader>tc', ts_context.toggle, 'Toggle treesitter context')
        end
    }
}

vim.pack.add (
    vim.tbl_map(function (spec)
        return { src = gh(spec[1]) }
    end, specs)
)

for _, spec in ipairs(specs) do
    if type(spec.config) == 'function' then
        spec.config()
    end
end

