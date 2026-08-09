local isLinux = vim.fn.has("linux") == 1

if not isLinux then
    return
end

local gh = require("utils.pack").gh
local picker_utils = require("utils.picker")

-- Register the plugin without loading it. `load = false` works like
-- `:packadd!`: it adds fzf-lua to 'runtimepath' but defers loading its
-- plugin/ files until `vim.cmd.packadd("fzf-lua")` is called.
vim.pack.add({ gh("ibhagwan/fzf-lua") }, { load = false })

local loaded = false

local function load()
    if loaded then
        return
    end
    loaded = true

    vim.cmd.packadd("fzf-lua")

    local vertical_picker_layout = {
        winopts = {
            preview = {
                layout = "vertical",
                vertical = "up:60%",
            },
        },
    }

    local fzf_lua = require("fzf-lua")
    fzf_lua.setup({
        files = { previewer = false },
        oldfiles = { previewer = false },
        buffers = vertical_picker_layout,
        grep = vertical_picker_layout,
        blines = vertical_picker_layout,

        lsp = {
            winopts = vertical_picker_layout,
            code_actions = { previewer = false },
        },
    }, true)

    fzf_lua.register_ui_select()

    return {
        blines = fzf_lua.blines,
        buffers = fzf_lua.buffers,
        builtin = fzf_lua.builtin,
        files = fzf_lua.files,
        oldfiles = fzf_lua.oldfiles,
        resume = fzf_lua.resume,
        undotree = fzf_lua.undotree,
        git_status = fzf_lua.git_status,
        git_commits = fzf_lua.git_commits,
        help_tags = fzf_lua.help_tags,
        keymaps = fzf_lua.keymaps,
        live_grep = fzf_lua.live_grep,
        lsp_declarations = fzf_lua.lsp_declarations,
        lsp_definitions = fzf_lua.lsp_definitions,
        lsp_document_symbols = fzf_lua.lsp_document_symbols,
        lsp_implementations = fzf_lua.lsp_implementations,
        lsp_references = fzf_lua.lsp_references,
        lsp_workspace_symbols = fzf_lua.lsp_workspace_symbols,
    }
end

picker_utils.map_pickers(load)

-- Lazy `vim.ui.select`: load fzf-lua (registering its ui-select provider)
-- on first use instead of at startup.
local orig_ui_select = vim.ui.select

local function lazy_ui_select(items, opts, on_choice)
    load()
    local current = vim.ui.select
    if current == lazy_ui_select then
        return orig_ui_select(items, opts, on_choice)
    end
    return current(items, opts, on_choice)
end

vim.ui.select = lazy_ui_select
