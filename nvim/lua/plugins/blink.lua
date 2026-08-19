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
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
			["<C-space>"] = { "show_documentation", "hide_documentation" },
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
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				scrolloff = 2,
				draw = {
					columns = { { "label", "kind", gap = 1 } },
					components = {
						label = {
							width = { fill = true, max = 60 },
						},
						kind = {
							width = { fill = false },
						},
					},
				},
			},
			documentation = {
				auto_show = false,
			},
		},
		signature = {
			enabled = false,
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
