return {
	"kawre/leetcode.nvim",
	cmd = { "Leet" },

	build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
	dependencies = {
		"ibhagwan/fzf-lua",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		-- configuration goes here
		---@type lc.lang
		lang = "java",
	},
	config = function(_, opts)
		require("leetcode").setup(opts)
		local cp = require("catppuccin.palettes").get_palette()

		vim.schedule(function()
			vim.api.nvim_set_hl(0, "leetcode_case_focus_ok", { fg = cp.base, bg = cp.green, bold = true })
			vim.api.nvim_set_hl(0, "leetcode_case_focus_err", { fg = cp.base, bg = cp.red, bold = true })
		end)
	end,
}
