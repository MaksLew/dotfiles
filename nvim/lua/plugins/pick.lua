return {
	"nvim-mini/mini.pick",
	version = false,
	keys = {
		{
			"<leader>f",
			function()
				require("mini.pick").builtin.cli({
					command = { "rg", "--files", "--hidden" },
				}, {
					source = { name = "Files" },
				})
			end,
			desc = "Find files",
		},
	},
	config = function()
		require("mini.pick").setup({
			mappings = {
				move_down = "<Tab>",
				move_up = "<S-Tab>",

				toggle_info = "",
				toggle_preview = "<S-CR>",
			},
		})
	end,
}
