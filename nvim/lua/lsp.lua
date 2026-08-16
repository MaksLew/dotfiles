local group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
local configured = false
local pinned_typst_main = {}
local notified_missing_typst_main = {}

local function find_typst_main(filename)
	return vim.fs.find(function(name)
		local stem, extension = name:match("^(.*)%.([^.]*)$")
		return extension == "typ" and stem:lower():find("main", 1, true) ~= nil
	end, {
		path = vim.fs.dirname(filename),
		upward = true,
		type = "file",
	})[1]
end

local function pin_typst_main(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" then
		return
	end

	for _, client in ipairs(vim.lsp.get_clients({ name = "tinymist", bufnr = bufnr })) do
		local main = find_typst_main(filename)

		-- Do not select a main file from above the LSP workspace.
		if main and client.root_dir and not vim.fs.relpath(client.root_dir, main) then
			main = nil
		end

		if not main then
			if not notified_missing_typst_main[client.id] then
				notified_missing_typst_main[client.id] = true
				vim.notify("Tinymist: no Typst file with 'main' in its stem found", vim.log.levels.INFO)
			end
			goto continue
		end

		main = vim.fs.normalize(main)
		if pinned_typst_main[client.id] == main then
			goto continue
		end

		pinned_typst_main[client.id] = main
		notified_missing_typst_main[client.id] = nil

		client:exec_cmd({
			title = "Pin Typst main file",
			command = "tinymist.pinMain",
			arguments = { main },
		}, { bufnr = bufnr }, function(err)
			if err then
				pinned_typst_main[client.id] = nil
				vim.notify(("Tinymist: could not pin %s: %s"):format(main, err.message or err), vim.log.levels.WARN)
				return
			end

			vim.notify(("Tinymist: pinned %s"):format(main), vim.log.levels.INFO)
		end)

		::continue::
	end
end

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

	vim.lsp.config("nil_ls", {
		cmd = { "nil" },
		filetypes = { "nix" },
		root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" },
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
		virtual_lines = { current_line = true },
		signs = {
			priority = 6,
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	vim.lsp.enable({ "lua_ls", "ty", "rust_analyzer", "nil_ls", "tinymist" })
end

configure()

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	pattern = "*.typ",
	callback = function(ev)
		pin_typst_main(ev.buf)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == "tinymist" then
			pin_typst_main(ev.buf)
		end

		local opts = { buf = ev.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code actions" })
		)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
	end,
})
