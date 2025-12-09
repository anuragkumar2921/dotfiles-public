return {
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					header = [[
                                                                                            
					                                                                                
					       ████ ██████           █████      ██                                
					      ███████████             █████                                       Z
					      █████████ ███████████████████ ███   ███████████         Z    
					     █████████  ███    █████████████ █████ ██████████████      z       
					    █████████ ██████████ █████████ █████ █████ ████ █████    z         
					  ███████████ ███    ███ █████████ █████ █████ ████ █████             
					 ██████  █████████████████████ ████ █████ █████ ████ ██████            

					          ]],
				},
			},
			terminal = {
				win = {
					position = "float",
					border = "rounded",
					width = 0.6,
					height = 0.6,
				},
			},
			lazygit = {
				win = {
					width = 0.9,
					height = 0.9,
				},
			},
			picker = {
				sources = {
					explorer = {
						layout = {
							auto_hide = { "input" },
						},
					},
				},
				win = {
					input = {
						keys = {
							["<S-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
							["<S-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
						},
					},
				},
			},
		},
	},
}
