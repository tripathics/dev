-- Diagnostic config
-- local icons = require('mini.icons').get('diagnostic', 'warning' )
-- local diagnostics_icons = {
--     ERROR = '',
--     WARN = '',
--     HINT = '',
--     INFO = '',
-- }
vim.schedule(function()
  vim.diagnostic.config({
    signs = {
      text = {
        ERROR = "",
        WARN  = "",
        INFO  = "",
        HINT  = "󰌵",
      },
    },
  })
end)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

local function onAttach(client_id, bufnr)
  local client = assert(vim.lsp.get_client_by_id(client_id))
  if not client then
    return false
  end

  ---Map keys for LSP actions
  ---@param keys string
  ---@param func function|string
  ---@param desc string
  ---@param mode string|string[]|nil
  local keymap = function (keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { desc = 'LSP: '..desc })
  end

  local snacks_picker = require('snacks').picker

  if client:supports_method('textDocument/documentColor', bufnr) then
    vim.lsp.document_color.enable(true, { bufnr }, { style = 'virtual' })
  end

  keymap('gd', snacks_picker.lsp_definitions, 'Peek definition')
  if client:supports_method('textDocument/definition', bufnr) then
    keymap('<C-]>', vim.lsp.buf.definition , 'Go to definition')
  end

  if client:supports_method('textDocument/references', bufnr) then
    keymap('rr', snacks_picker.lsp_references, 'Find references')
  end
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
