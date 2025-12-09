return {
	"windwp/nvim-ts-autotag",
	event = "LazyFile",
	opts = {
		-- Exclude markdown files from auto-tagging
		per_filetype = {
			["markdown"] = {
				enable_close = false,
			},
		},
	},
}
