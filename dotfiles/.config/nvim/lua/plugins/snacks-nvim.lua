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
            win = {
                -- preview window
                preview = {
                    wo = {
                        number = false,
                        relativenumber = false,
                        signcolumn = "no",
                        foldcolumn = "0",
                        cursorline = false,
                    },
                },
                -- input window
                input = {
                    keys = {
                        ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                        ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    },
                },
            },
            sources = {
                lines = {
                    win = {
                        preview = {
                            wo = {
                                number = true,
                                relativenumber = false,
                                signcolumn = "yes",
                                foldcolumn = "auto",
                            },
                        },
                    },
                },
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
            "<leader>ff",
            function()
                Snacks.picker.files()
            end,
            desc = "Find Files",
        },
        {
            "<leader>fn",
            function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find nvim config",
        },
        {
            "<leader>fg",
            function()
                Snacks.picker.grep()
            end,
            desc = "Grep in files",
        },
        {
            "<leader>fs",
            function()
                Snacks.picker()
            end,
            desc = "Find Pickers",
        },
        {
            "<leader>/",
            function()
                Snacks.picker.lines()
            end,
            desc = "Find Pickers",
        },
        {
            "<leader>fh",
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
