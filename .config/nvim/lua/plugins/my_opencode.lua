return {
	"nickjvandyke/opencode.nvim",
	version = "*", -- Latest stable release
	dependencies = {
		{
			-- `snacks.nvim` integration is recommended, but optional
			---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
			"folke/snacks.nvim",
			optional = true,
			opts = {
				input = {}, -- Enhances `ask()`
				picker = { -- Enhances `select()`
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		local map = vim.keymap.set

		---@type opencode.Opts
		vim.g.opencode_opts = {
			server = {
				port = 7890,
				start = function()
					require("opencode.terminal").start("opencode --port 7890")
				end,
				stop = function()
					require("opencode.terminal").stop()
				end,
				toggle = function()
					require("opencode.terminal").toggle("opencode --port 7890")
				end,
			},
		}

		vim.o.autoread = true -- Required for `opts.events.reload`

		-- Recommended/example keymaps
		map({ "n", "x" }, "<leader>aa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode…" })

		map({ "n", "x" }, "<leader>ax", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })

		map({ "n", "t" }, "<leader>a.", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })

		map({ "n", "x" }, "<leader>ao", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })

		map("n", "<leader>aoo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		map("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })

		map("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })
	end,
}
