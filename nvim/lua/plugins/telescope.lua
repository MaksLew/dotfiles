return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				path_display = { "truncate" },
				file_ignore_patterns = {
					"node_modules",
					".git/",
					"dist",
					"build",
					"target",
					".venv",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = false,
				},
			},
		})
		require("telescope").load_extension("fzf")
	end,
}
