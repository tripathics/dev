---@module 'lazy'
---@type LazySpec
return {
    "nvim-mini/mini.surround",
    opts = {
        ---@module 'mini.surround'
        mappings = {
            add = "gsa",
            delete = "gsd",
            find = "gsf", -- Find surrounding (to the right)
            find_left = "gsF", -- Find surrounding (to the left)
            highlight = "gsh", -- Highlight surrounding
            replace = "gsr", -- Replace surrounding
          -- suffix_last = 'l', -- Suffix to search with "prev" method
          -- suffix_next = 'n', -- Suffix to search with "next" method
        },
        search_method = "cover_or_next",
    },
}
