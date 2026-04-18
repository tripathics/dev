-- Picker
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
                require("snacks").picker.buffers()
            end,
            desc = "Find Buffers",
        },
        {
            "<leader>sf",
            function()
                require("snacks").picker.files()
            end,
            desc = "Find Files",
        },
        {
            "<leader>sn",
            function()
                require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find nvim config",
        },
        {
            "<leader>sg",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Grep in files",
        },
        {
            "<leader>ss",
            function()
                require("snacks").picker()
            end,
            desc = "Find Pickers",
        },
        {
            "<leader>u",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Grep in files",
        },
    },
}
