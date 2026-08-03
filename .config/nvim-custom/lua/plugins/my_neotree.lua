return {
	"nvim-neo-tree/neo-tree.nvim",
  enabled = false,
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<leader>e",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
			end,
			desc = "Explorer NeoTree (Root Dir)",
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		-- Auto-open neo-tree when opening a directory
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Neo-tree with directory",
			once = true,
			callback = function()
				if package.loaded["neo-tree"] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("neo-tree")
					end
				end
			end,
		})
	end,
	opts = {
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
		},
		buffers = {
			follow_current_file = { enabled = true },
		},
		git_status = {
			follow_current_file = { enabled = true },
		},
		window = {
			mappings = {
				-- Vim-like navigation
				["l"] = "open",
				["h"] = "close_node",
			},
		},
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "▶",
				expander_expanded = "▼",
			},
		},
	},
}
