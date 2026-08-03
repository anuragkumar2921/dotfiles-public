return {
	"windwp/nvim-ts-autotag",
	event = function()
		return {}
	end,
	ft = {
		"html",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	opts = {
		-- Exclude markdown files from auto-tagging
		per_filetype = {
			["markdown"] = {
				enable_close = false,
			},
		},
	},
}
