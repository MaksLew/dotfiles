return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "LSP references" },
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
