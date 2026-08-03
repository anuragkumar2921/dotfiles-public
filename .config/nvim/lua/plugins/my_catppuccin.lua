return {
	"catppuccin/nvim",
	name = "catppuccin",
	opts = {
		flavour = "mocha",
		transparent_background = true,
		float = {
			transparent = true,
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
