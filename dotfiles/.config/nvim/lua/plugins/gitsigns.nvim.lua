return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    current_line_blame = true,
    opts = {
      on_attach = function (bufnr)
        local gs = package.loaded.gitsigns

        ---Map keys for working with hunks
        ---@param keys string
        ---@param func function
        ---@param desc string
        local nmap = function (keys, func, desc)
          vim.keymap.set('n', keys, func, { desc = 'GitSigns: '..desc, buf = bufnr })
        end

        nmap('[h', function () gs.nav_hunk'prev' end, 'Prev hunk')
        nmap(']h', function () gs.nav_hunk'next' end, 'Next hunk')
        nmap('<leader>hb', gs.blame, 'Open Blame')
        nmap('<leader>hp', gs.preview_hunk, 'Preview hunk')
        nmap('<leader>hr', gs.reset_hunk, 'Reset hunk')
        nmap('<leader>hs', gs.stage_hunk, 'Stage hunk')
        nmap('<leader>hd', gs.diffthis, 'Open diff')
      end
    }
  }
