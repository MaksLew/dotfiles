return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			no_italic = true,
			no_bold = true,
			no_underline = true,
			custom_highlights = function()
				return {
					CursorLineNr = { fg = "#f9e2af" },
					LineNr = { fg = "#a6adc8" },
				}
			end,
		})
		vim.cmd("colorscheme catppuccin")
	end,
}
