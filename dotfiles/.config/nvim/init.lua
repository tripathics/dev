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

require('lazy').setup({
  require('plugins.themes'),
  'tpope/vim-fugitive',
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

--- need to move this later
vim.lsp.config['lua_ls'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc' },
    -- NOTE: These will be merged with the configuration file.
    settings = {
        Lua = {
            completion = { callSnippet = 'Replace' },
            -- Using stylua for formatting.
            format = { enable = false },
            hint = {
                enable = true,
                arrayIndex = 'Disable',
            },
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                },
            },
        },
    },
}
vim.lsp.enable('lua_ls')

vim.keymap.set('n', '\\', function()
  vim.cmd 'Lex!'
end, { desc = 'Open netrw' })
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

require('vim._core.ui2').enable {}
