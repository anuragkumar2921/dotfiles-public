return {
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					keys = {
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
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
				-- win = {
				-- 	position = "float",
				-- 	border = "rounded",
				-- 	width = 0.6,
				-- 	height = 0.6,
				-- },
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
			styles = {
				snacks_image = {
					relative = "editor",
					col = -1,
				},
			},
			image = {
				enabled = true,
				doc = {
					inline = false,
					float = true,
					max_width = 80,
					max_height = 40,
				},
			},
		},
	},
}
