local gh = require("utils.pack").gh

vim.pack.add({
    {
        src = gh("stevearc/conform.nvim"),
        load = false,
    },
})

local conform

local function load_conform()
    if conform then
        return conform
    end

    vim.cmd.packadd("conform.nvim")

    conform = require("conform")

    conform.setup({
        formatters_by_ft = {
            lua = { "stylua" },
            htmlangular = { "prettier" },
            html = { "prettier" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        notify_on_error = true,
        notify_no_formatters = true,
    })

    return conform
end

local group = vim.api.nvim_create_augroup(
    "tripathics/format_on_save",
    { clear = true }
)

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function()
        if not vim.g.format_on_save then
            return
        end

        load_conform().format({
            lsp_format = "fallback",
            timeout_ms = 500,
        })
    end,
})

vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
    load_conform()

    vim.g.format_on_save = not (vim.g.format_on_save or false)

    local state = vim.g.format_on_save and "Enabled" or "Disabled"
    vim.notify(state .. ": Format on save", vim.log.levels.INFO)
end, {
    desc = "Toggle format on save",
})

vim.keymap.set("n", "<leader>b", function()
    load_conform().format()
end, {
    desc = "Format buffer",
})

vim.keymap.set("n", "<leader>tb", "<cmd>ToggleFormatOnSave<cr>", {
    desc = "Toggle format on save",
})
