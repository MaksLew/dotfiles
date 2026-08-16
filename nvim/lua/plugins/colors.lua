return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		local colors = require("catppuccin.palettes").get_palette("mocha")
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			no_italic = true,
			no_bold = true,
			no_underline = true,
			custom_highlights = function()
				return {
					CursorLine = { bg = "NONE" },
					CursorLineNr = { fg = colors.blue },
					LineNr = { fg = colors.overlay1 },
				}
			end,
		})
		vim.cmd("colorscheme catppuccin")
	end,
}
