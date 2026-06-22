return {
	"saghen/blink.cmp",
	event = "VeryLazy",
	version = "v1.*",
	opts = {
		keymap = {
			preset = "none",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<CR>"] = { "select_and_accept", "fallback" },
		},
		sources = {
			default = { "lsp", "path" },
			providers = {
				lsp = {
					score_offset = 1000,
				},
				path = {
					score_offset = 3,
				},
			},
		},
		completion = {
			list = {
				selection = {
					auto_insert = false,
				},
			},
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					columns = {
						{ "label" },
						{ "kind", gap = 1 },
					},
				},
			},
		},
		signature = {
			enabled = true,
			trigger = {
				show_on_trigger_character = false,
				show_on_insert_on_trigger_character = false,
			},
			window = {
				show_documentation = true,
			},
		},
	},
}
