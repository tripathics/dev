return {
    "saghen/blink.cmp",
    build = "cargo build --release",
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = "default" },
        fuzzy = { implementation = "prefer_rust" },
        signature = { enabled = true },
    },
}
