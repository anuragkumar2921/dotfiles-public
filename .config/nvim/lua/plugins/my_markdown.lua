return {
	{
		"MeanderingProgrammer/markdown.nvim",
		ft = "markdown",
		main = "render-markdown",
		opts = {
			code = {
				disable_background = false,
				highlight_border = false,
				width = "block",
			},
			heading = {
				width = "block",
			},
		},
		name = "render-markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	},
	{
		"Gowa2017/markdown-preview.nvim",
		ft = "markdown",
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
	{
		"bullets-vim/bullets.vim",
		ft = "markdown",
		config = function()
			vim.g.bullets_delete_last_bullet_if_empty = 1
		end,
	},
	{
		"opdavies/toggle-checkbox.nvim",
		ft = "markdown",
		keys = {
			{
				"<leader>mt",
				ft = "markdown",
				":lua require('toggle-checkbox').toggle()<CR>",
				desc = "Toggle checkbox",
			},
		},
	},
	{
		"HakonHarnes/img-clip.nvim",
		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = false,
				use_absolute_path = false,
			},
			drag_and_drop = {
				enabled = false,
			},
		},
		keys = {
			{ "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
		},
	},
}
