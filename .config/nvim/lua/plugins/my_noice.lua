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
				event = "lsp",
				kind = "progress",
				find = "jdtls",
			},
			opts = { skip = true },
		})

		-- local focused = true
		-- vim.api.nvim_create_autocmd("FocusGained", {
		--   callback = function()
		--     focused = true
		--   end,
		-- })
		-- vim.api.nvim_create_autocmd("FocusLost", {
		--   callback = function()
		--     focused = false
		--   end,
		-- })
		-- table.insert(opts.routes, 1, {
		--   filter = {
		--     cond = function()
		--       return not focused
		--     end,
		--   },
		--   view = "notify_send",
		--   opts = { stop = false },
		-- })
		--
		-- opts.commands = {
		--   all = {
		--     -- options for the message history that you get with `:Noice`
		--     view = "split",
		--     opts = { enter = true, format = "details" },
		--     filter = {},
		--   },
		-- }
		--
		-- vim.api.nvim_create_autocmd("FileType", {
		--   pattern = "markdown",
		--   callback = function(event)
		--     vim.schedule(function()
		--       require("noice.text.markdown").keys(event.buf)
		--     end)
		--   end,
		-- })

		opts.presets.lsp_doc_border = true
	end,
}
