-- Picker

---@module 'lazy'
---@type LazySpec
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
        picker = {
            enabled = true,
            sources = {
                lsp_definitions = {
                    layout = {
                        preset = "dropdown", -- or "dropdown", "vertical", etc.
                    },
                },
                lsp_references = {
                    layout = {
                        preset = "dropdown",
                    },
                },
                lsp_implementations = {
                    layout = {
                        preset = "dropdown",
                    },
                },
                lsp_type_definitions = {
                    layout = {
                        preset = "dropdown",
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader><space>",
            function()
                Snacks.picker.buffers()
            end,
            desc = "Find Buffers",
        },
        {
            "<leader>sf",
            function()
                Snacks.picker.files()
            end,
            desc = "Find Files",
        },
        {
            "<leader>sn",
            function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find nvim config",
        },
        {
            "<leader>sg",
            function()
                Snacks.picker.grep()
            end,
            desc = "Grep in files",
        },
        {
            "<leader>ss",
            function()
                Snacks.picker()
            end,
            desc = "Find Pickers",
        },
        {
            "<leader>sh",
            function()
                Snacks.picker.help()
            end,
            desc = "Find Pickers",
        },
        {
            "<leader>u",
            function()
                Snacks.picker.undo()
            end,
            desc = "Grep in files",
        },
    },
}
