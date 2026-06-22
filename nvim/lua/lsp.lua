local group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
local configured = false

local function configure()
	if configured then
		return
	end
	configured = true

	vim.lsp.config("lua_ls", {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
			},
		},
	})

	vim.lsp.config("ty", {
		cmd = { "ty", "server" },
		filetypes = { "python" },
		root_markers = { "pyproject.toml" },
		settings = {
			ty = {
				completions = {
					autoImport = false,
				},
			},
		},
	})

	vim.lsp.config("rust_analyzer", {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", ".git" },
	})

	vim.lsp.config("tinymist", {
		cmd = { "tinymist" },
		filetypes = { "typst" },
		root_markers = { "typst.toml", ".git" },
		settings = {
			formatterMode = "typstyle",
		},
	})

	vim.diagnostic.config({
		virtual_text = false,
		signs = {
			priority = 6,
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	vim.lsp.enable({ "lua_ls", "ty", "rust_analyzer", "tinymist" })
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "lua", "python", "rust", "typst" },
	callback = function()
		vim.defer_fn(configure, 100)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
	end,
})
