return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		local function apply_theme()
			local scheme = vim.fn.system({ "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" })
			vim.o.background = scheme:find("prefer-dark", 1, true) and "dark" or "light"
			vim.cmd.colorscheme(vim.o.background == "dark" and "catppuccin" or "iceberg")
			if vim.o.background == "light" then
				vim.api.nvim_set_hl(0, "Normal", { fg = "#33374c", bg = "NONE" })
				vim.api.nvim_set_hl(0, "StatusLine", { fg = "#33374c", bg = "NONE" })
				vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#8389a3", bg = "NONE" })
				for _, name in ipairs({
					"CursorLine",
					"CursorLineNr",
					"CursorLineSign",
					"CursorLineFold",
					"LineNr",
					"LineNrAbove",
					"LineNrBelow",
					"SignColumn",
					"FoldColumn",
					"DiagnosticSignError",
					"DiagnosticSignWarn",
					"DiagnosticSignInfo",
					"DiagnosticSignHint",
					"DiagnosticSignOk",
					"GitGutterAdd",
					"GitGutterChange",
					"GitGutterChangeDelete",
					"GitGutterDelete",
				}) do
					local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
					hl.bg = nil
					vim.api.nvim_set_hl(0, name, hl)
				end
			end
		end

		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			no_italic = true,
			no_bold = true,
			no_underline = true,
			custom_highlights = function()
				return {
					CursorLineNr = { fg = colors.blue },
					CursorLine = { bg = "NONE" },
					LineNr = { fg = colors.overlay1 },
				}
			end,
		})
		vim.cmd("colorscheme catppuccin")
	end,
}
