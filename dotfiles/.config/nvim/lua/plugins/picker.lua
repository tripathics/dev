local isWindows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local isLinux = vim.fn.has("linux") == 1

---@class PickerActions
---@field buffers fun(opts?: table)
---@field files fun(opts?: table)
---@field git_status fun(opts?: table)
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
local function picker_keymaps(pickers)
    ---@param keys string
    ---@param func function|string
    ---@param desc string
    ---@param mode string|string[]|nil
    local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { desc = desc })
    end

    map("<leader><space>", pickers.buffers, "Find Buffers")
    map("<leader>ff", pickers.files, "[F]ind Files")
    map("<leader>fn", function()
        pickers.files({ cwd = vim.fn.stdpath("config") })
    end, "Find Files")
    map("<leader>fg", pickers.git_status, "[F]ind [G]it status")
    map("<leader>fh", pickers.help_tags, "[F]ind [H]elp tags")
    map("<leader>fr", pickers.resume, "[F]ind [R]esume")
    map("<leader>fs", pickers.live_grep, "[F]ind Live Grep [S]earch")
    map("<leader>f.", pickers.oldfiles, "[F]ind Old files")
    map("<leader>/", pickers.blines, "Search Buf Lines")
    map("<leader>fp", pickers.builtin, "[F]ind builtins")
    map("<leader>u", pickers.undotree, "[F]ind [U]ndotree")

    local lspKeysGroup = vim.api.nvim_create_augroup("tripathics/lsp-keys-group", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = lspKeysGroup,
        callback = function(ev)
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
                    pickers.lsp_definitions({ jump1 = true })
                end, "Go to definition")
                keymap("gD", function()
                    pickers.lsp_definitions({ jump1 = false })
                end, "Peek definition")
            end

            keymap("rr", pickers.lsp_references, "Find references")
            keymap("gri", pickers.lsp_implementations, "Implementation")
            keymap("grd", pickers.lsp_definitions, "Find definitions")
            keymap("grD", pickers.lsp_declarations, "Find declarations")
            keymap("gW", pickers.lsp_workspace_symbols, "Workspace Symbols")
            keymap("gO", pickers.lsp_document_symbols, "Document Symbols")
        end,
    })
end

return {
    {
        "ibhagwan/fzf-lua",
        enabled = isLinux,
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
                blines = {
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

            picker_keymaps({
                blines = FzfLua.blines,
                buffers = FzfLua.buffers,
                builtin = FzfLua.builtin,
                files = FzfLua.files,
                oldfiles = FzfLua.oldfiles,
                resume = FzfLua.resume,
                undotree = FzfLua.undotree,
                git_status = FzfLua.git_status,
                help_tags = FzfLua.help_tags,
                live_grep = FzfLua.live_grep,
                lsp_declarations = FzfLua.lsp_declarations,
                lsp_definitions = FzfLua.lsp_definitions,
                lsp_document_symbols = FzfLua.lsp_document_symbols,
                lsp_implementations = FzfLua.lsp_implementations,
                lsp_references = FzfLua.lsp_references,
                lsp_workspace_symbols = FzfLua.lsp_workspace_symbols,
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        enabled = isWindows,
        -- event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",

                -- Determine whether to load/install the plugin
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<c-q>"] = require("telescope.actions").send_to_qflist
                                + require("telescope.actions").open_qflist,
                            ["<c-l>"] = require("telescope.actions").send_to_loclist
                                + require("telescope.actions").open_loclist,
                        },
                    },
                },
                -- pickers = {}
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            local themes = require("telescope.themes")
            picker_keymaps({
                blines = function()
                    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                    builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                        winblend = 10,
                        previewer = false,
                    }))
                end,
                buffers = builtin.buffers,
                builtin = builtin.builtin,
                files = function ()
                    builtin.find_files(themes.get_dropdown({
                        previewer = false,
                    }))
                end,
                live_grep = builtin.live_grep,
                git_status = builtin.git_status,
                help_tags = builtin.help_tags,
                oldfiles = builtin.oldfiles,
                resume = builtin.resume,
                undotree = builtin.undotree,
                lsp_references = builtin.lsp_references,
                lsp_definitions = builtin.lsp_definitions,
                lsp_document_symbols = builtin.lsp_document_symbols,
                lsp_workspace_symbols = builtin.lsp_workspace_symbols,
                lsp_implementations = builtin.lsp_implementations,
                lsp_declarations = function () end
            })
        end,
    },
}
