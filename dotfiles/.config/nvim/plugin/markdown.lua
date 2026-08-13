local add = require('utils.pack').add

add {
    {
        src = 'MeanderingProgrammer/render-markdown.nvim',
        name = 'render-markdown',
        config = function()
            local render_md = require 'render-markdown'
            render_md.setup {
                file_types = { 'markdown', 'codecompanion' },
            }
        end,
        events = { 'FileType' },
        keys = {
            {
                '<leader>tm',
                function() require('render-markdown').buf_toggle() end,
                desc = 'Toggle render markdown',
            },
        },
    },
}
