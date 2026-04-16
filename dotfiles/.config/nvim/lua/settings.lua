-- [[ Setting options ]]

-- Use <space> as leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- indentation (2 spaces, JS)
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Look and feel
vim.opt.guifont = 'Lilex:h14'
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.showmode = false
vim.opt.signcolumn = 'yes'

vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'

vim.opt.linebreak = true
vim.opt.list = true     -- list (show) invisible characters
vim.opt.listchars = { tab = '» ', trail = '·' }
vim.opt.breakindent = true

-- folds
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- how/when we split
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.undofile = true
vim.opt.confirm = true
vim.opt.mouse = 'a'

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- completion (took from maria solos)
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.pumheight = 15
