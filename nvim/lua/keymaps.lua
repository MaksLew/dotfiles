local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("n", "<Esc>", "<Esc>:noh<CR>", { silent = true })
keymap("n", "<leader>-", ":split<CR>", vim.tbl_extend("force", opts, { desc = "Split horizontally" }))
keymap("n", "<leader>|", ":vsplit<CR>", vim.tbl_extend("force", opts, { desc = "Split vertically" }))

vim.api.nvim_create_user_command("W", "write <args>", { nargs = "*" })
