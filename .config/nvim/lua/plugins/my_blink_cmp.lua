return {
	"saghen/blink.cmp",
	event = "VeryLazy",
	lazy = true,
	opts = function(_, opts)
		opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
			["<C-k>"] = { "select_prev", "fallback" }, -- Navigate to the previous suggestion
			["<C-j>"] = { "select_next", "fallback" }, -- Navigate to the next suggestion
		})

		opts.completion = vim.tbl_extend("force", opts.completion or {}, {
			list = {
				selection = { auto_insert = true },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "rounded",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
				},
			},
			menu = {
				border = "rounded",
				draw = { gap = 2 },
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
			},
		})
		return opts
	end,
}
