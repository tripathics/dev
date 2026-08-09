local gh = require('utils.pack').gh

vim.pack.add({ { src = gh("j-hui/fidget.nvim"), name = "fidget" } })

require("fidget").setup {}
