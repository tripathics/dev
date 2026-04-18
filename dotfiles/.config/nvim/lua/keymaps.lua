-- [[ Basic Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- resizing windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -4<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +4<CR>", { desc = "Increase window width" })

-- keep everything centered while scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and go to center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and go to center" })

-- indentation
vim.keymap.set("v", ">", ">gv", { desc = "Indent right staying in visual mode" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left staying in visual mode" })

-- [[ MISC ]]
-- cd into current file parent dir
vim.keymap.set("n", "<leader>.", function()
    vim.cmd("cd %:p:h")
    vim.notify(vim.fn.getcwd())
end, { desc = "Change directory to the directory containing the current file" })

-- buffer keymaps
vim.keymap.set("n", "<C-w>c", "<cmd>hide<CR>", { desc = "[C]lose window" })

-- Terminal keymaps
TERM = vim.uv.os_uname().sysname ~= "Linux" and "bash" or nil

vim.keymap.set("n", "<leader>tt", function()
    vim.cmd.tabnew()
    vim.cmd.term(TERM)
end, { desc = "Open a [t]erminal in new [t]ab" })

vim.keymap.set("n", "<leader>ts", function()
    vim.cmd.vnew()
    vim.cmd.term(TERM)
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 15)
end, { desc = "Open a [t]erminal [s]mall" })
