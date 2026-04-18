local textYankGroup = vim.api.nvim_create_augroup("text-yank-group", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = textYankGroup,
    callback = function()
        vim.highlight.on_yank()
    end,
})
