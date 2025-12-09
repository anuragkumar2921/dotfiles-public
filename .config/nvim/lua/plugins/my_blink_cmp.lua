return {
	"saghen/blink.cmp",
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

		opts.cmdline = vim.tbl_extend("force", opts.cmdline or {}, {
			completion = {
				menu = { auto_show = false },
				ghost_text = { enabled = false },
			},
			keymap = {
				["<C-j>"] = { "select_next" },
				["<C-k>"] = { "select_prev" },
			},
		})

		-- Make blink.cmp toogleable
		vim.g.completion = true

		Snacks.toggle({
			name = "Completion",
			get = function()
				return vim.g.completion
			end,
			set = function(state)
				vim.g.completion = state
			end,
		}):map("<leader>uk")

		opts.enabled = function()
			return vim.g.completion ~= false
		end

		return opts
	end,
}
