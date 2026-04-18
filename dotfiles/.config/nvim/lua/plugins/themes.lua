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
        priority = 1000,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd.colorscheme("kanagawa-dragon")
        end,
    },
    { "nvim-mini/mini.base16" },
    { "nvim-mini/mini.hues" },
}
