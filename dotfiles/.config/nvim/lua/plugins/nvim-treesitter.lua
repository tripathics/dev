---@module 'lazy'
---@type LazySpec
return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            -- Avoid the sticky context from growing a lot.
            max_lines = 3,
            -- Match the context lines to the source code.
            multiline_threshold = 1,
            -- Disable it when the window is too small.
            min_window_height = 20,
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
