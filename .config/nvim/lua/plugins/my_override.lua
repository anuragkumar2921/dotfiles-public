return {
	{
		"nvim-mini/mini.pairs",
		event = function()
			return "InsertEnter"
		end,
	},
	{
		"nvim-mini/mini.ai",
		event = function()
			return "LazyFile"
		end,
	},
	{
		"folke/ts-comments.nvim",
		event = function()
			return "LazyFile"
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = function()
			return "LazyFile"
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = function()
			return "LazyFile"
		end,
	},
}
