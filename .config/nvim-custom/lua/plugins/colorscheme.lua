return {
	-- "folke/tokyonight.nvim",
	-- priority = 1000,
	-- config = function()
	-- 	require("tokyonight").setup({})
	--
	-- 	vim.cmd.colorscheme("tokyonight-night")
	-- end,

	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
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
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
