return {
	"neovim/nvim-lspconfig",
	opts = {
		inlay_hints = { enabled = false },
		diagnostics = {
			float = {
				border = "rounded",
				width = 40,
			},
		},
		servers = {
			gopls = {
				settings = {
					gopls = {
						buildFlags = { "-tags=wireinject,!wireinject" },
						analyses = {
							ST1000 = false, -- Disable package comment check
						},
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
