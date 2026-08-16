vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

require("nvim-surround").buffer_setup({
	surrounds = {
		m = {
			add = { "$", "$" },
			find = "%$.-%$",
			delete = "^(.)().-(.)()$",
		},
		M = {
			add = { "$ ", " $" },
			find = "%$.-%$",
			delete = "^(.)().-(.)()$",
		},
	},
})

local expr_opts = { buf = 0, expr = true }

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)

local math_query = vim.treesitter.query.parse("typst", "(math) @math")

local function find_math_on_or_after_cursor(row, column)
	local tree = vim.treesitter.get_parser(0, "typst"):parse()[1]
	local containing
	local following

	for _, node in math_query:iter_captures(tree:root(), 0, row, row + 1) do
		local start_row, start_column, end_row, end_column = node:range()

		if start_row == row and end_row == row then
			if start_column <= column and column < end_column then
				containing = { start_column, end_column }
				break
			elseif start_column >= column and (not following or start_column < following[1]) then
				following = { start_column, end_column }
			end
		end
	end

	return containing or following
end

local function toggle_math_spacing()
	local line = vim.api.nvim_get_current_line()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local math_range = find_math_on_or_after_cursor(cursor[1] - 1, cursor[2])

	if not math_range then
		return
	end

	local opening_column = math_range[1]
	local closing_column = math_range[2] - 1
	local content = line:sub(opening_column + 2, closing_column)
	local spaced = content:sub(1, 1) == " " and content:sub(-1) == " "
	local replacement
	local cursor_delta
	local line_delta

	if spaced then
		replacement = "$" .. content:sub(2, -2) .. "$"
		cursor_delta = -1
		line_delta = -2
	else
		replacement = "$ " .. content .. " $"
		cursor_delta = 1
		line_delta = 2
	end

	local cursor_column = cursor[2]

	vim.api.nvim_buf_set_text(0, cursor[1] - 1, opening_column, cursor[1] - 1, math_range[2], { replacement })

	if cursor_column >= closing_column then
		cursor_column = cursor_column + line_delta
	elseif cursor_column > opening_column then
		cursor_column = cursor_column + cursor_delta
	end

	vim.api.nvim_win_set_cursor(0, { cursor[1], math.max(opening_column, cursor_column) })
end

vim.keymap.set("n", "<leader>m", toggle_math_spacing, {
	buf = 0,
	desc = "Toggle Typst math spacing",
})
