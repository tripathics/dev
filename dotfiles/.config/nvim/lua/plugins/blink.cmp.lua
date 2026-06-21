---@module 'lazy'
---@type LazySpec
return {
    "saghen/blink.cmp",
    build = "cargo build --release",
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "default",
            ["<C-d>"] = { "scroll_documentation_down" },
            ["<C-u>"] = { "scroll_documentation_up" },
        },
        fuzzy = { implementation = "prefer_rust" },
        completion = {
            accept = { auto_brackets = { enabled = false } },
            documentation = {
                auto_show = false,
                treesitter_highlighting = false,
            },
            menu = {
                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                    },
                },
            },
        },
        signature = {
            enabled = true,
            trigger = { enabled = false },
        },
        sources = { default = { "lsp", "path", "snippets" } },
    },
}
