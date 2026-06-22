return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({
			delay = 100,
			preset = "helix",
			spec = {
				{ "gO", desc = "List symbols" },
			},
		})
	end,
}
