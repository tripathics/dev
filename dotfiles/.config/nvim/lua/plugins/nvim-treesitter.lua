---@module 'lazy'
---@type LazySpec
return {
    "tripathics/nvim-treesitter",
    -- dir = "~/projects/nvim-treesitter",
    -- name = "nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
        prefer_git = true,
    },
    config = function(_, opts)
        require("nvim-treesitter").setup(opts)

        -- make sure the following are installed
        require("nvim-treesitter").install({
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
        })
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        ---@module 'treesitter-context'
        ---@type TSContext.Config
        ---
        ---@diagnostic disable:missing-fields
        opts = {
            enable = true,
            -- Avoid the sticky context from growing a lot.
            max_lines = 3,
            -- Match the context lines to the source code.
            multiline_threshold = 1,
            -- Disable it when the window is too small.
            min_window_height = 20,
            -- line_numbers = true,
            trim_scope = "inner",
        },
        keys = {
            {
                "[n",
                function()
                    vim.schedule(function()
                        require("treesitter-context").go_to_context()
                    end)
                    return "<Ignore>"
                end,
                desc = "Jump to upper context",
                expr = true,
            },
        },
    },
}
