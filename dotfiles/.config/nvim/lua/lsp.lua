-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

local function onAttach(client_id, bufnr)
  local client = assert(vim.lsp.get_client_by_id(client_id))
  if not client then
    return false
  end

  -- local keymap = function ()
  --
  -- end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('tripathics/lsp-group', { clear = true }),
  callback = function(ev)
    onAttach(ev.data.client_id, ev.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function ()
    vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
    local servers = vim.iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function (file) return vim.fn.fnamemodify(file, ':t:r') end)
      :totable()
    vim.lsp.enable(servers)
  end
})
