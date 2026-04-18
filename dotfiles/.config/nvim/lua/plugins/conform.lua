---@module 'lazy'
---@type LazySpec
return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = {
                lsp_format = "fallback",
                timeout_ms = 500,
            },
            notify_on_error = true,
            notify_no_formatters = true,
        })
        vim.keymap.set("n", "<leader>f", function()
            require("conform").format()
        end, { desc = "Format buffer" })
    end,
}
