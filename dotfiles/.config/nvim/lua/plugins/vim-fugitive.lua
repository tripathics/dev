---@module 'lazy'
---@type LazySpec
return {
    "tpope/vim-fugitive",
    keys = {
        {"<leader>gs", vim.cmd.Git, desc = "[G]it status" },
        {"<leader>gc", "<cmd>0Gclog!<CR>", desc = "[G]it [l]og this file" },
        {"<leader>gd", "<cmd>Gvdiffsplit!<CR>", desc = "[G]it [d]iff this" },
        {"<leader>gD", ":Gvdiffsplit HEAD~1 ", desc = "[G]it [D]iff command" },
        {"gu", "<cmd>diffget //2<CR>", desc = "[G]it ours" },
        {"gh", "<cmd>diffget //3<CR>", desc = "[G]et theirs" },
    },
}
