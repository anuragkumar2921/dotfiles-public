return {
	"folke/which-key.nvim",
	event = function()
		return "LazyFile"
	end,
	opts = {
		defer = function(ctx)
			return ctx.mode == "v" or ctx.mode == "<C-V>" or ctx.mode == "V"
		end,
		delay = 2000,
	},
}
