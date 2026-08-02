return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = "VeryLazy",
	build = function()
		require("nvim-treesitter")
			.install({
				"rust",
				"python",
				"lua",
				"typst",
				"vim",
				"vimdoc",
				"nix",
			})
			:wait(300000)
	end,
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		local function start_treesitter(buf)
			local filetype = vim.bo[buf].filetype
			local lang = vim.treesitter.language.get_lang(filetype)
			if lang then
				pcall(vim.treesitter.start, buf, lang)
			end
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
			callback = function(ctx)
				start_treesitter(ctx.buf)
			end,
		})

		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				start_treesitter(buf)
			end
		end
	end,
}
