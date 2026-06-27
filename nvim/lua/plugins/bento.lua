return {
	"serhez/bento.nvim",
	branch = "feat/v2",
	lazy = false,
	config = function()
		require("bento").setup()

		local api = require("bento.api")

		api.register_expand_key(";")
		api.register_last_buffer_key(";")
		api.register_collapse_key("<Esc>")
		api.register_prev_page_key("[")
		api.register_next_page_key("]")

		api.register_action("open", {
			key = "<CR>",
			action = api.actions.open,
			hl = "DiagnosticVirtualTextHint",
		})
		api.register_action("delete", {
			key = "<BS>",
			action = api.actions.delete,
			hl = "DiagnosticVirtualTextError",
		})
		api.register_action("vsplit", {
			key = "|",
			action = api.actions.vsplit,
			hl = "DiagnosticVirtualTextInfo",
		})
		api.register_action("split", {
			key = "_",
			action = api.actions.split,
			hl = "DiagnosticVirtualTextInfo",
		})
		api.register_action("lock", {
			key = "*",
			action = api.actions.lock,
			hl = "DiagnosticVirtualTextWarn",
		})

		api.set_default_action("open")
	end,
}
