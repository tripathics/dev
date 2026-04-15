-- Install lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath
  }
end
vim.opt.rtp:prepend(lazypath)

require 'settings'
require 'keymaps'
-- commands
require 'autocmds'
require 'lsp'

require('lazy').setup({
  require('plugins.themes'),
  'tpope/vim-fugitive',
  'nvim-treesitter/nvim-treesitter',    -- so that I can install parsers with TSInstall
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function ()
      local layout_actions = require('telescope.actions.layout')
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ['<C-p>'] = layout_actions.cycle_layout_next,
              ['<C-S-p>'] = layout_actions.cycle_layout_prev,
            }
          }
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_ivy()
          }
        }
      })
      require('telescope').load_extension('ui-select')
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require("gitsigns").setup({
        on_attach = function ()
        end
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  { 'j-hui/fidget.nvim', opts = {} },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    'saghen/blink.cmp',
    build = 'cargo build --release',
    opts = {
      keymap = { preset = 'default' },
      fuzzy = { implementation = 'prefer_rust' },
    },
  },
}, {
  performance = {
    rtp = {
     -- Stuff I don't use. (copied from maria's config
      disabled_plugins = {
        'gzip',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

vim.keymap.set('n', '\\', function()
  vim.cmd 'Lex!'
end, { desc = 'Open netrw' })
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

require('vim._core.ui2').enable {}
