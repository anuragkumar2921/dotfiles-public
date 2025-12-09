return {
	"ibhagwan/fzf-lua",
	opts = function(_, opts)
		local fzf = require("fzf-lua")
		local config = fzf.config

		config.defaults.keymap.builtin = vim.tbl_extend("force", config.defaults.keymap.builtin or {}, {
			["<S-j>"] = "preview-down",
			["<S-k>"] = "preview-up",
		})

		return opts
	end,
}
