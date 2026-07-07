vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

local expr_opts = { buffer = true, expr = true }

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
