return {
	{
		"MeanderingProgrammer/markdown.nvim",
		event = "VeryLazy",
		main = "render-markdown",
		opts = {},
		name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you use the mini.nvim suite
	},
	{
		"iamcco/markdown-preview.nvim",
		requires = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
		event = "VeryLazy",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},
	-- This plugin automatically adds bulletpoints on the next line respecting
	-- indentation
	-- In markdown or a text file start a bulleted list using - or *. Press return
	-- to go to the next line, a new list item will be created.
	--
	-- When in insert mode, you can increase indentation with ctrl+t and decrease it
	-- with ctrl+d
	--
	-- By default its enabled on filetypes 'markdown', 'text', 'gitcommit', 'scratch'
	-- https://github.com/bullets-vim/bullets.vim
	{
		"bullets-vim/bullets.vim",
		event = "VeryLazy",
		config = function()
			-- Disable deleting the last empty bullet when pressing <cr> or 'o'
			-- default = 1
			vim.g.bullets_delete_last_bullet_if_empty = 1
			-- (Optional) Add other configurations here
			-- For example, enabling/disabling mappings
			-- vim.g.bullets_set_mappings = 1
		end,
	},
	{
		"opdavies/toggle-checkbox.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>mt",
				ft = "markdown",
				":lua require('toggle-checkbox').toggle()<CR>",
				desc = "Toggle checkbox",
			},
		},
	},
}
