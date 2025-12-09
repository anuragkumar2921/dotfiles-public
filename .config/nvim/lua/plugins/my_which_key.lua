return {
	"folke/which-key.nvim",
	opts = {
		defer = function(ctx)
			return ctx.mode == "v" or ctx.mode == "<C-V>" or ctx.mode == "V"
		end,
		delay = 2000,
	},
}
