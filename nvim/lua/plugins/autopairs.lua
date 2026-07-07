return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local autopairs = require("nvim-autopairs")
			local cond = require("nvim-autopairs.conds")
			local Rule = require("nvim-autopairs.rule")

			autopairs.setup()
			autopairs.add_rule(Rule("$", "$", "typst"):with_move(cond.after_text("$")))
		end,
	},
}
