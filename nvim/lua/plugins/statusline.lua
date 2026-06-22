return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
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
						color = { gui = "none" },
					},
				},
				lualine_b = {
					{
						"diagnostics",
						symbols = { error = "E", warn = "W", info = "I", hint = "H" },
					},
				},
				lualine_c = {
					{
						"filename",
					},
				},
				lualine_x = {
					"branch",
				},
				lualine_y = {
					"diff",
				},
				lualine_z = {
					{
						"location",
						color = { gui = "none" },
					},
				},
			},
		})
	end,
}
