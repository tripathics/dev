local isWindows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local isLinux = vim.fn.has("linux") == 1

local picker_utils = require("utils.picker")

---@type LazySpec[]
return {
    {   -- fzf-lua for linux
        "ibhagwan/fzf-lua",
        enabled = isLinux,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local fzf_lua = require("fzf-lua")

            local vertical_picker_layout = {
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
            }

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

            picker_utils.map_pickers({
                blines = FzfLua.blines,
                buffers = FzfLua.buffers,
                builtin = FzfLua.builtin,
                files = FzfLua.files,
                oldfiles = FzfLua.oldfiles,
                resume = FzfLua.resume,
                undotree = FzfLua.undotree,
                git_status = FzfLua.git_status,
                git_commits = FzfLua.git_commits,
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
        keys = vim.tbl_values(picker_utils.keys),
    },
    {   -- telescope for windows
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

            local actions = require("telescope.actions")
            local builtin = require("telescope.builtin")
            local themes = require("telescope.themes")
            require("telescope").setup({
                defaults = {
                    layout_strategy = "vertical",
                    sorting_strategy = "ascending",

                    mappings = {
                        i = {
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-l>"] = actions.send_to_loclist + actions.open_loclist,
                        },
                    },

                    layout_config = {
                        width = 0.8,
                        height = 0.95,

                        vertical = {
                            prompt_position = "top",
                            preview_cutoff = 20,
                        },
                    },
                },

                pickers = {
                    find_files = {
                        previewer = false,
                    },

                    oldfiles = {
                        previewer = false,
                    },

                    live_grep = {
                        layout_strategy = "vertical",
                    },

                    current_buffer_fuzzy_find = {
                        layout_strategy = "vertical",
                    },

                    lsp_references = {
                        layout_strategy = "vertical",
                    },

                    lsp_definitions = {
                        layout_strategy = "vertical",
                    },

                    lsp_implementations = {
                        layout_strategy = "vertical",
                    },

                    lsp_type_definitions = {
                        layout_strategy = "vertical",
                    },
                },

                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown(),
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            picker_utils.map_pickers({
                blines = function()
                    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                    builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                        winblend = 10,
                        previewer = false,
                    }))
                end,
                buffers = builtin.buffers,
                builtin = builtin.builtin,
                files = builtin.find_files,
                live_grep = builtin.live_grep,
                git_status = builtin.git_status,
                git_commits = builtin.git_commits,
                help_tags = builtin.help_tags,
                oldfiles = builtin.oldfiles,
                resume = builtin.resume,
                undotree = function() -- telescope don't have builtin undotree
                    vim.cmd("packadd undotree")
                    vim.cmd("Undotree")
                end,
                lsp_references = builtin.lsp_references,
                lsp_definitions = builtin.lsp_definitions,
                lsp_document_symbols = builtin.lsp_document_symbols,
                lsp_workspace_symbols = builtin.lsp_workspace_symbols,
                lsp_implementations = builtin.lsp_implementations,
                lsp_declarations = function() end,
            })
        end,
        keys = vim.tbl_values(picker_utils.keys),
    },
}
