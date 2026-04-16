return {
    'nvim-mini/mini.files',
    dependencies = { 'nvim-mini/mini.icons' },
    config = function ()
      local mini_files = require('mini.files')
      mini_files.setup {
        options = {
          use_as_default_explorer = true,
        },
        windows = {
          max_number = 4,
        }
      }

      vim.keymap.set('n', '\\', mini_files.open, { desc = 'Files: Open explorer' })
      vim.keymap.set('n', '<leader>e', function ()
        local p = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
        if p == nil then
          mini_files.open()
        else
          mini_files.open(p)
        end
      end, { desc = 'Files: Open explorer in current file dir' })
    end,
  }
