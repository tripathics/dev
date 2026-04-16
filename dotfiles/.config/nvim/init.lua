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

require('lazy').setup('plugins', {
  performance = {
    rtp = {
     -- Stuff I don't use. (copied from maria's config
      disabled_plugins = {
        'netrw',
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

require('vim._core.ui2').enable {}
