return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',

      -- Determine whether to load/install the plugin
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
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
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<c-q>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
            ['<c-l>'] = require('telescope.actions').send_to_loclist + require('telescope.actions').open_loclist,
          },
        },
      },
      -- pickers = {}
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>fp', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    -- vim.keymap.set('n', '<leader>s/', function()
    --   builtin.live_grep {
    --     grep_open_files = true,
    --     prompt_title = 'Live Grep in Open Files',
    --   }
    -- end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })


    local telescopeLspKeysGroup = vim.api.nvim_create_augroup("tripathics/telescope-lsp-keys-group", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = telescopeLspKeysGroup,
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
                    builtin.lsp_definitions({ jump1 = true })
                end, "Go to definition")
                keymap("gD", function()
                    builtin.lsp_definitions({ jump1 = false })
                end, "Peek definition")
            end

            keymap("rr", builtin.lsp_references, "Find references")
            keymap("gri", builtin.lsp_implementations, "Implementation")
            keymap("grd", builtin.lsp_definitions, "Peek definition")
            -- keymap("grD", builtin.lsp_declarations, "Peek definition")
            keymap("gW", builtin.lsp_workspace_symbols, "Workspace Symbols")
            keymap("gO", builtin.lsp_document_symbols, "Document Symbols")
        end
    })
  end,
}
