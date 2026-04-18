-- Diagnostic config
vim.schedule(function()
    vim.diagnostic.config({
        signs = {
            text = {
                ERROR = "",
                WARN = "",
                INFO = "",
                HINT = "󰌵",
            },
        },
    })
end)

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--- Setup keymaps and autocmds for given buffer
---@param client_id integer
---@param bufnr integer
---@return boolean
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
    local keymap = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { desc = "LSP: " .. desc })
    end

    local snacks_picker = require("snacks").picker

    -- those color previews beside colors in say css
    if client:supports_method("textDocument/documentColor", bufnr) then
        vim.lsp.document_color.enable(true, { bufnr }, { style = "virtual" })
    end

    if client:supports_method("textDocument/definition", bufnr) then
        keymap("gd", function()
            snacks_picker.lsp_definitions()
        end, "Go to definition")
        keymap("gD", function()
            snacks_picker.lsp_definitions({ auto_confirm = false })
        end, "Peek definition")
    end

    keymap("grn", vim.lsp.buf.rename, "Implementation")

    keymap("rr", snacks_picker.lsp_references, "Find references")
    keymap("gri", snacks_picker.lsp_implementations, "Implementation")
    keymap("grd", snacks_picker.lsp_definitions, "Peek definition")
    keymap("grD", snacks_picker.lsp_declarations, "Peek definition")
    keymap("gW", snacks_picker.lsp_workspace_symbols, "Workspace Symbols")
    keymap("gO", snacks_picker.lsp_symbols, "Document Symbols")
    keymap("gK", function()
        local new_virtual_text = not vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = new_virtual_text })
    end, "Toggle diagnoistic virtual lines")

    if client:supports_method("textDocument/documentHighlight") then
        local under_cursor_highlights_group =
            vim.api.nvim_create_augroup("tripathics/cursor_highlights", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            group = under_cursor_highlights_group,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = under_cursor_highlights_group,
            callback = vim.lsp.buf.clear_references,
        })
    end

    return true
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("tripathics/lsp-group", { clear = true }),
    callback = function(ev)
        onAttach(ev.data.client_id, ev.buf)
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function()
        vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
        local servers = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
            :map(function(file)
                return vim.fn.fnamemodify(file, ":t:r")
            end)
            :totable()
        vim.lsp.enable(servers)
    end,
})
