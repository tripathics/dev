local gh = require("utils.pack").gh

vim.pack.add({
    gh("nvim-lua/plenary.nvim"),
    gh("nvim-treesitter/nvim-treesitter"),
    { src = gh("olimorris/codecompanion.nvim") },
})

local codecompanion

local function load_codecompanion()
    if codecompanion then
        return codecompanion
    end
    codecompanion = require("codecompanion")
    codecompanion.setup({
        adapters = {
            deepseek = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    env = {
                        api_key = os.getenv("DEEPSEEK_API_KEY"),
                    },
                })
            end,
        },
        strategies = {
            chat = { adapter = "deepseek" },
            inline = { adapter = "deepseek" },
            agent = { adapter = "deepseek" },
        },
    })

    return codecompanion
end

---@param lhs string
---@param rhs fun(companion: CodeCompanion): nil
---@param desc string|nil
---@param mode string|nil
local function map(lhs, rhs, desc, mode)
    mode = mode or "n"

    vim.keymap.set(mode, lhs, function()
        local companion = load_codecompanion()
        rhs(companion)
    end, { desc = desc })
end

map("<leader>ca", function(companion) companion.actions({}) end, "Code Companion Actions")
map("<leader>ct", function(companion) companion.toggle() end, "Code Companion Toggle")

map("<leader>cv", function(companion) companion.add {
    vim.fn.line("'<"), vim.fn.line("'>")
} end, "Code Companion Toggle", "v")

