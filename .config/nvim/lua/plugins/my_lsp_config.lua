return {
	"neovim/nvim-lspconfig",
	opts = {
		inlay_hints = { enabled = false },
		servers = {
			gopls = {
				settings = {
					gopls = {
						buildFlags = { "-tags=wireinject,!wireinject" },
					},
				},
			},
			clangd = {
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			},
			cssls = {
				settings = {
					css = {
						lint = { unknownAtRules = "ignore" },
					},
				},
			},
		},
	},
}
