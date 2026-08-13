local isLinux = vim.fn.has 'linux' == 1

if isLinux then return end

local picker_utils = require 'utils.picker'
local gh = require('utils.pack').gh

vim.pack.add({
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
}, { load = false })

local loaded = false

local function load()
    if loaded then return end
    loaded = true

    vim.cmd.packadd 'plenary.nvim'
    vim.cmd.packadd 'telescope.nvim'
    vim.cmd.packadd 'telescope-ui-select.nvim'

    local actions = require 'telescope.actions'
    local builtin = require 'telescope.builtin'
    local themes = require 'telescope.themes'

    require('telescope').setup {
        defaults = {
            layout_strategy = 'vertical',
            sorting_strategy = 'ascending',

            mappings = {
                i = {
                    ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                    ['<C-l>'] = actions.send_to_loclist + actions.open_loclist,
                },
            },

            layout_config = {
                width = 0.8,
                height = 0.95,

                vertical = {
                    prompt_position = 'top',
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
                layout_strategy = 'vertical',
            },

            current_buffer_fuzzy_find = {
                layout_strategy = 'vertical',
            },

            lsp_references = {
                layout_strategy = 'vertical',
            },

            lsp_definitions = {
                layout_strategy = 'vertical',
            },

            lsp_implementations = {
                layout_strategy = 'vertical',
            },

            lsp_type_definitions = {
                layout_strategy = 'vertical',
            },
        },

        extensions = {
            ['ui-select'] = themes.get_dropdown(),
        },
    }

    pcall(require('telescope').load_extension, 'ui-select')

    return {
        blines = function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(themes.get_dropdown {
                winblend = 10,
                previewer = false,
            })
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
            vim.cmd 'packadd undotree'
            vim.cmd 'Undotree'
        end,
        keymaps = builtin.keymaps,
        lsp_references = builtin.lsp_references,
        lsp_definitions = builtin.lsp_definitions,
        lsp_document_symbols = builtin.lsp_document_symbols,
        lsp_workspace_symbols = builtin.lsp_workspace_symbols,
        lsp_implementations = builtin.lsp_implementations,
    }
end

picker_utils.map_pickers(load)

-- Lazy `vim.ui.select`: load telescope's ui-select extension on first use.
local orig_ui_select = vim.ui.select

local function lazy_ui_select(items, opts, on_choice)
    load()
    local current = vim.ui.select
    if current == lazy_ui_select then return orig_ui_select(items, opts, on_choice) end
    return current(items, opts, on_choice)
end

vim.ui.select = lazy_ui_select
