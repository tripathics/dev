-- Picker
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    picker = { enabled = true },
  },
  keys = {
    { "<leader><space>", function() require('snacks').picker.buffers() end, desc = "Find Buffers" },
    { "<leader>sf", function() require('snacks').picker.files() end, desc = "Find Files" },
    { "<leader>sn", function() require('snacks').picker.files { cwd = vim.fn.stdpath('config') } end, desc = "Find nvim config" },
    { "<leader>sg", function() require('snacks').picker.grep() end, desc = "Grep in files" },
  },
}
