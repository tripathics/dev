local M = {}

local picker_keys = {
    buffers = "<leader><space>",
    files = "<leader>ff",
    nvim_config_files = "<leader>fn",
    git_status = "<leader>fg",
    git_commits = "<leader>fc",
    help_tags = "<leader>fh",
    resume = "<leader>fr",
    live_grep = "<leader>fs",
    oldfiles = "<leader>f.",
    blines = "<leader>/",
    builtin = "<leader>fp",
    undotree = "<leader>u",

    lsp_references = "rr",
    lsp_implementations = "gri",
    lsp_definitions = "grd",
    lsp_declarations = "grD",
    lsp_workspace_symbols = "gW",
    lsp_document_symbols = "gO",
}

M.keys = picker_keys

---@class PickerActions
---@field buffers fun(opts?: table)
---@field files fun(opts?: table)
---@field git_status fun(opts?: table)
---@field git_commits fun(opts?: table)
---@field help_tags fun(opts?: table)
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
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { desc = desc })
    end

    map(picker_keys.buffers, pickers.buffers, "Find Buffers")
    map(picker_keys.files, pickers.files, "[F]ind Files")
    map("<leader>fn", function()
        pickers.files({ cwd = vim.fn.stdpath("config") })
    end, "Find Files")
    map(picker_keys.git_status, pickers.git_status, "[F]ind [G]it status")
    map(picker_keys.git_commits, pickers.git_commits, "[F]ind Git [C]ommits")
    map(picker_keys.help_tags, pickers.help_tags, "[F]ind [H]elp tags")
    map(picker_keys.resume, pickers.resume, "[F]ind [R]esume")
    map(picker_keys.live_grep, pickers.live_grep, "[F]ind Live Grep [S]earch")
    map(picker_keys.oldfiles, pickers.oldfiles, "[F]ind Old files")
    map(picker_keys.blines, pickers.blines, "Search Buf Lines")
    map(picker_keys.builtin, pickers.builtin, "[F]ind builtins")
    map(picker_keys.undotree, pickers.undotree, "[F]ind [U]ndotree")

    local lspKeysGroup = vim.api.nvim_create_augroup("tripathics/lsp-keys-group", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = lspKeysGroup,
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local bufnr = ev.buf

            if not client then
                return
            end

            if client:supports_method("textDocument/definition", bufnr) then
                map("gd", function()
                    pickers.lsp_definitions({ jump1 = true })
                end, "LSP: Go to definition")
                map("gD", function()
                    pickers.lsp_definitions({ jump1 = false })
                end, "LSP: Peek definition")
            end

            map(picker_keys.lsp_references, pickers.lsp_references, "LSP: Find references")
            map(picker_keys.lsp_implementations, pickers.lsp_implementations, "LSP: Implementation")
            map(picker_keys.lsp_definitions, pickers.lsp_definitions, "LSP: Find definitions")
            map(picker_keys.lsp_declarations, pickers.lsp_declarations, "LSP: Find declarations")
            map(picker_keys.lsp_workspace_symbols, pickers.lsp_workspace_symbols, "LSP: Workspace Symbols")
            map(picker_keys.lsp_document_symbols, pickers.lsp_document_symbols, "LSP: Document Symbols")
        end,
    })
end

return M
