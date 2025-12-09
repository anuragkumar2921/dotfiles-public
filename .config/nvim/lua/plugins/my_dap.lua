return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<F1>",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<F2>",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		opts = {
			expand_lines = true,
			controls = { enabled = false },
			floating = { border = "rounded" },

			render = {
				max_type_length = 60,
				max_value_lines = 200,
			},

			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.8 },
						{ id = "repl", size = 0.2 },
					},
					size = 10,
					position = "bottom",
				},
			},
		},
	},
}
