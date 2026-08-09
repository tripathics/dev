local gh = require("utils.pack").gh

vim.pack.add({
    { src = gh("MeanderingProgrammer/render-markdown.nvim"), name = "render-markdown" },
}, {
    load = false,
})

local render_md

local function load_render_md()
    if render_md then
        return render_md
    end

    vim.cmd.packadd("render-markdown")
    render_md = require("render-markdown")
    render_md.setup({
        file_types = { "markdown", "codecompanion" },
    })

    return render_md
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        -- local ft = vim.bo[args.buf].filetype
        -- if not vim.tbl_contains({ "codecompanion", "markdown" }, ft) then
        --     return
        -- end

        local md = load_render_md()

        -- The plugin missed this buffer because it was just loaded.
        -- Force attach it.
        pcall(md.buf_enable, args.buf)

        vim.keymap.set("n", "<leader>tm", function()
            md.buf_toggle()
        end, { desc = "Toggle render markdown", buf = args.buf })
    end,
})
