local textYankGroup = vim.api.nvim_create_augroup("text-yank-group", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = textYankGroup,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- now we have to autostart treesitter ourselves
local treesitterStartGroup = vim.api.nvim_create_augroup('tripathics/treesitter_start_group', { clear= true})
vim.api.nvim_create_autocmd('FileType', {
    group = treesitterStartGroup,
    callback = function (args)
        local bufnr = args.buf
        -- again copied from maria
        if vim.bo[bufnr].filetype ~= 'bigfile' then
            pcall(vim.treesitter.start, bufnr)
        end
    end
})
