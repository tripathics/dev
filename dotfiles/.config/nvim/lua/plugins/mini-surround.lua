---@module 'lazy'
---@type LazySpec
return {
    "nvim-mini/mini.surround",
    opts = {
        ---@module 'mini.surround'
        mappings = {
            add = "<leader>sa",
            delete = "<leader>sd",
            find = "<leader>sf", -- Find surrounding (to the right)
            find_left = "<leader>sF", -- Find surrounding (to the left)
            highlight = "<leader>sh", -- Highlight surrounding
            replace = "<leader>sr", -- Replace surrounding
          -- suffix_last = 'l', -- Suffix to search with "prev" method
          -- suffix_next = 'n', -- Suffix to search with "next" method
        },
        search_method = "cover_or_next",
    },
}
