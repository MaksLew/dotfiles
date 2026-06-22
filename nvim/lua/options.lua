local opt = vim.opt

vim.o.background = "dark"
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.scrolloff = 10
opt.signcolumn = "yes:2"
opt.cursorline = true
opt.laststatus = 3
vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
]])

vim.diagnostic.config({
	signs = false,
	virtual_text = false,
})

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.wrap = false
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.clipboard = "unnamedplus"
opt.mouse = ""
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300

opt.swapfile = false
opt.backup = false
opt.undofile = true
