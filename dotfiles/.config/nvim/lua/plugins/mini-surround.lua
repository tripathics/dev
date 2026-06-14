---@module 'lazy'
---@type LazySpec
return {
    "nvim-mini/mini.surround",
    opts = {
        mappings = {
            add = "gsa",
            delete = "gsd",
        },
        search_method = "cover_or_next",
    },
}
