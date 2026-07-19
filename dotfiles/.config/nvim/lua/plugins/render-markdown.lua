---@module 'lazy'
---@type LazySpec
return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {},
    keys = {
        {
            "<leader>tm",
            function()
                require("render-markdown").buf_toggle()
            end,
            desc = "Toggle render [m]arkdown"
        },
    },
}
