return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		local mode_color = function()
			local colors = require("catppuccin.palettes").get_palette("mocha")
			local mode_colors = {
				n = colors.blue,
				i = colors.green,
				v = colors.mauve,
				V = colors.mauve,
				["\22"] = colors.mauve, -- visual block
				c = colors.yellow,
				s = colors.pink,
				S = colors.pink,
				["\19"] = colors.pink, -- select block
				R = colors.peach,
				r = colors.peach,
				t = colors.teal,
			}
			return {
				fg = mode_colors[vim.fn.mode()] or colors.blue,
				bg = "NONE",
				gui = "none",
			}
		end

		require("lualine").setup({
			options = {
				section_separators = "",
				component_separators = "",
				always_show_tabline = false,
				refresh = {
					statusline = 500,
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						color = mode_color,
						fmt = function(mode)
							return mode:sub(1, 1)
						end,
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						color = mode_color,
					},
				},
				lualine_x = {},
				lualine_y = {
					{
						"diagnostics",
						symbols = { error = "E", warn = "W", info = "I", hint = "H" },
						color = mode_color,
					},
				},
				lualine_z = {
					{
						"location",
						color = mode_color,
					},
				},
			},
		})
	end,
}
