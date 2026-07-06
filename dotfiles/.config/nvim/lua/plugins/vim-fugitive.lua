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

        ---@param lhs string
        ---@param rhs function|string
        ---@param desc string
        ---@param mode string|string[]|nil
        local function map(lhs, rhs, desc, mode)
            mode = mode or "n"
            vim.keymap.set("n", lhs, rhs, { desc = desc })
        end

        map("<leader>gs", vim.cmd.Git, "[G]it status")
        map("<leader>gc", "<cmd>0Gclog!<CR>",  "[G]it [l]og this file")
        map("<leader>gd", "<cmd>Gvdiffsplit!<CR>",  "[G]it [d]iff this")
        map("<leader>gD", ":Gvdiffsplit HEAD~1 ",  "[G]it [D]iff command")
        map("gu", "<cmd>diffget //2<CR>", "[G]it ours")
        map("gh", "<cmd>diffget //3<CR>",  "[G]et theirs")
    end,
}
