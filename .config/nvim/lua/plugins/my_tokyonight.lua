return {
	"tokyonight.nvim",
	opts = {
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
		custom_highlights = function(colors)
			return {
				-- CursorLine = { bg = "none" },
				-- StatusLine = { bg = colors.mantle },
				NormalSB = { bg = colors.none },
			}
		end,
	},
}
