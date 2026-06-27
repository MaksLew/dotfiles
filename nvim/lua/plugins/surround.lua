return {
	{
		"kylechui/nvim-surround",
		version = "3.*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = false,
					insert_line = false,
					normal_cur_line = false,
					change_line = false,
				},
			})
		end,
	},
}
