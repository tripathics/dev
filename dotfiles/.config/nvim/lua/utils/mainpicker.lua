local M = {}

local picker_defs = {
    buffers = { keys = '<leader><space>', desc = 'Find Buffers' },
    files = { keys = '<leader>ff', desc = 'Find Files' },
    nvim_config_files = { keys = '<leader>fn', desc = 'Find Nvim config' },
    git_status = { keys = '<leader>fg', desc = 'Find Git status' },
    git_commits = { keys = '<leader>fc', desc = 'Find Git Commits' },
    help_tags = { keys = '<leader>fh', desc = 'Find Help tags' },
    keymaps = { keys = '<leader>fk', desc = 'Find Keymaps' },
    resume = { keys = '<leader>fr', desc = 'Find Resume' },
    live_grep = { keys = '<leader>fs', desc = 'Find live grep Search' },
    oldfiles = { keys = '<leader>f.', desc = 'Find old files' },
    blines = { keys = '<leader>/', desc = 'Search Buf Lines' },
    builtin = { keys = '<leader>fp', desc = 'Find builtin Pickers' },
    undotree = { keys = '<leader>u', desc = 'Find Undotree' },
    lsp_references = { keys = 'rr', desc = 'LSP: Find References' },
    lsp_implementations = { keys = 'gri', desc = 'LSP: Implementation' },
    lsp_definitions = { keys = 'grd', desc = 'LSP: Find definitions' },
    lsp_declarations = { keys = 'grD', desc = 'LSP: Find declarations' },
    lsp_workspace_symbols = { keys = 'gW', desc = 'LSP: Workspace Symbols' },
    lsp_document_symbols = { keys = 'gO', desc = 'LSP: Document Symbols' },
}

-- use in lazy spec keys
M.keymaps = vim.tbl_values(vim.tbl_map(function(def) return { def.keys, desc = def.desc } end, picker_defs))

---@class PickerActions
---@field buffers fun(opts?: table)
---@field files fun(opts?: table)
---@field git_status fun(opts?: table)
---@field git_commits fun(opts?: table)
---@field help_tags fun(opts?: table)
---@field keymaps fun(opts?: table)
---@field resume fun(opts?: table)
---@field live_grep fun(opts?: table)
---@field oldfiles fun(opts?: table)
---@field blines fun(opts?: table)
---@field builtin fun(opts?: table)
---@field undotree fun(opts?: table)
---@field lsp_definitions fun(opts?: table)
---@field lsp_references fun(opts?: table)
---@field lsp_implementations fun(opts?: table)
---@field lsp_declarations fun(opts?: table)
---@field lsp_workspace_symbols fun(opts?: table)
---@field lsp_document_symbols fun(opts?: table)
---
---@param pickers PickerActions
M.map_pickers = function(pickers)
    ---@param keys string
    ---@param func function|string
    ---@param desc string
    ---@param mode string|string[]|nil
    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { desc = desc })
    end

    for name, def in pairs(picker_defs) do
        local key = def.keys
        local picker_fn = pickers[name]
        if picker_fn and type(picker_fn) == 'function' then vim.keymap.set('n', key, picker_fn, { desc = def.desc }) end
    end

    vim.keymap.set(
        'n',
        picker_defs.nvim_config_files.keys,
        function() pickers.files { cwd = vim.fn.stdpath 'config' } end,
        { desc = picker_defs.nvim_config_files.desc }
    )

    local lspKeysGroup = vim.api.nvim_create_augroup('tripathics/lsp-keys-group', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
        group = lspKeysGroup,
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local bufnr = ev.buf

            if not client then return end

            if client:supports_method('textDocument/definition', bufnr) then
                map('gd', function() pickers.lsp_definitions { jump1 = true } end, 'LSP: Go to definition')
                map('gD', function() pickers.lsp_definitions { jump1 = false } end, 'LSP: Peek definition')
            end

            for _, name in ipairs {
                'lsp_references',
                'lsp_implementations',
                'lsp_definitions',
                'lsp_declarations',
                'lsp_workspace_symbols',
                'lsp_document_symbols',
            } do
                local def = picker_defs[name]
                if pickers[name] then vim.keymap.set('n', def.keys, pickers[name], { desc = def.desc }) end
            end
        end,
    })
end

return M
