return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			component_separators = " ",
			section_separators = " ",
		},
		sections = {
			lualine_c = {
				-- LazyVim.lualine.root_dir(),
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{ LazyVim.lualine.pretty_path() },
			},
			lualine_x = {
				{
					"diagnostics",
					symbols = {
						error = LazyVim.config.icons.diagnostics.Error,
						warn = LazyVim.config.icons.diagnostics.Warn,
						info = LazyVim.config.icons.diagnostics.Info,
						hint = LazyVim.config.icons.diagnostics.Hint,
					},
				},
				{
					"diff",
					symbols = {
						added = "+",
						modified = "~",
						removed = "-",
					},
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
				},
			},
			lualine_y = {
				{ "progress", separator = " ", padding = { left = 1, right = 0 } },
			},
			lualine_z = {
				{ "location", padding = { left = 1, right = 1 } },
			},
		},
	},
}
