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
        if vim.bo[bufnr].filetype ~= 'bigfile' and pcall(vim.treesitter.start, bufnr) then
            vim.api.nvim_buf_call(bufnr, function()
                vim.wo[0][0].foldmethod = 'expr'
                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.cmd.normal 'zx'
            end)
        end
    end
})
