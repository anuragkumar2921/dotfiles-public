return {
	"folke/noice.nvim",
	opts = function(_, opts)
		table.insert(opts.routes, {
			filter = {
				event = "notify",
				find = "Pending...",
			},
			opts = { skip = true },
		})
		table.insert(opts.routes, {
			filter = {
				event = "notify",
				find = "Judging...",
			},
			opts = { skip = true },
		})
		table.insert(opts.routes, {
			filter = {
				find = "Add 'silent=true' to hide this message.",
			},
			opts = { skip = true },
		})
		table.insert(opts.routes, {
			filter = {
				event = "notify",
				find = "No information available",
			},
			opts = { skip = true },
		})
		table.insert(opts.routes, {
			filter = {
				event = "lsp",
				kind = "progress",
				find = "jdtls",
			},
			opts = { skip = true },
		})

		opts.presets.lsp_doc_border = true

		-- Add LSP hover documentation configuration
		opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
			hover = {
				enabled = true,
				opts = {
					size = {
						max_height = 20,
						max_width = 70,
					},
				},
			},
		})

		opts.cmdline = {
			enabled = false,
		}
		opts.messages = {
			enabled = false,
		}
		opts.views = {
			mini = {
				position = {
					row = -2,
					col = "100%",
				},
			},
		}
	end,
}
