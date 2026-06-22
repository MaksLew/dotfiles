return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			default_format_opts = {
				async = true,
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			format_after_save = function(_)
				return {
					async = true,
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				python = { "ruff_format" },
				rust = { "rustfmt" },
				typst = { "typstyle" },
				lua = { "stylua" },
			},
		},
	},
}
