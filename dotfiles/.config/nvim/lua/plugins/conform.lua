---@module 'lazy'
---@type LazySpec
return {
    "stevearc/conform.nvim",
    init = function()       -- so that it exists even before the plugin has loaded
        vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
            local format_on_save = vim.g.format_on_save or false ---@type boolean
            vim.g.format_on_save = not format_on_save
            local state = vim.g.format_on_save and "Enabled" or "Disabled"
            vim.notify(state .. ": Format on save", vim.log.levels.INFO)
        end, { desc = "Toggle format on save" })
    end,
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            notify_on_error = true,
            notify_no_formatters = true,
        })

        local group = vim.api.nvim_create_augroup("tripathics/format_on_save", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = group,
            callback = function()
                if not vim.g.format_on_save then
                    return
                end
                require("conform").format({
                    lsp_format = "fallback",
                    timeout_ms = 500,
                })
            end,
        })
    end,
    -- load the plugin with these keys
    keys = {
        {
            "<leader>b",
            function()
                require("conform").format()
            end,
            desc = "Format buffer",
        },
        {
            "<leader>tb",
            "<cmd>ToggleFormatOnSave<CR>",
            desc = "Toggle format on save",
        },
    },
}
