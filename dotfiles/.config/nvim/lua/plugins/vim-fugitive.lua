---@module 'lazy'
---@type LazySpec
return {
    "tpope/vim-fugitive",
    config = function()
        local fugitiveGroup = vim.api.nvim_create_augroup("tripathics/fugitive-keymaps", {})
        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = fugitiveGroup,
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }

                -- rebase always (like prime)
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull --rebase" })
                end, { desc = "Fugitive: pull with rebase" })

                -- enter the git push command
                vim.keymap.set("n", "<leader>p", ":Git push -u origin ", vim.tbl_extend("force", opts, { desc = "Fugitive: push command" }))
            end,
        })
    end,
    keys = {
        { "gs", vim.cmd.Git,  { desc = "[G]it status" }},
        { "gu", "<cmd>diffget //2<CR>",  { desc = "[G]et ours" }},
        { "gh", "<cmd>diffget //3<CR>",  { desc = "[G]et theirs" }}
    }
}
