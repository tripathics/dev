-- Picker

---@module 'Lazy'
---@type LazySpec
return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        local fzf_lua = require("fzf-lua")
        fzf_lua.setup({
            files = {
                previewer = false,
            },
            oldfiles = {
                previewer = false,
            },
            grep = {
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
            },
            lines = {
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
            },

            lsp = {
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
                code_actions = {
                    previewer = false,
                },
            },
        }, true)

        fzf_lua.register_ui_select()

        ---@param keys string
        ---@param func function|string
        ---@param desc string
        ---@param mode string|string[]|nil
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { desc = desc })
        end

        map("<leader><space>", FzfLua.buffers, "Find Buffers")
        map("<leader>ff", FzfLua.files, "Find Files")
        map("<leader>fn", function()
            FzfLua.files({ cwd = vim.fn.stdpath("config") })
        end, "Find Files")
        map("<leader>fg", FzfLua.git_status, "[F]zfLua [G]it status")
        map("<leader>fh", FzfLua.help_tags, "[F]zfLua [H]elp tags")
        map("<leader>fr", FzfLua.resume, "[F]zfLua [R]esume")
        map("<leader>fs", FzfLua.live_grep, "[F]zfLua Live Grep [S]earch")
        map("<leader>f.", FzfLua.oldfiles, "[F]zfLua Old files")
        map("<leader>/", FzfLua.lines, "Search Lines")
        map("<leader>fp", FzfLua.builtin, "[F]zfLua builtins")

        local fzfLuaLspKeysGroup = vim.api.nvim_create_augroup("tripathics/fzf-lua-lsp-keys-group", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
            group = fzfLuaLspKeysGroup,
            callback = function (ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                local bufnr = ev.buf

                if not client then
                    return
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

                if client:supports_method("textDocument/definition", bufnr) then
                    keymap("gd", function()
                        FzfLua.lsp_definitions({ jump1 = true })
                    end, "Go to definition")
                    keymap("gD", function()
                        FzfLua.lsp_definitions({ jump1 = false })
                    end, "Peek definition")
                end

                keymap("rr", FzfLua.lsp_references, "Find references")
                keymap("gri", FzfLua.lsp_implementations, "Implementation")
                keymap("grd", FzfLua.lsp_definitions, "Peek definition")
                keymap("grD", FzfLua.lsp_declarations, "Peek definition")
                keymap("gW", FzfLua.lsp_workspace_symbols, "Workspace Symbols")
                keymap("gO", FzfLua.lsp_document_symbols, "Document Symbols")
            end
        })
    end,
}
