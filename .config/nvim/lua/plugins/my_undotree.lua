return {
	"mbbill/undotree",
	config = function()
		-- Optional: Add keybindings or configuration here
		vim.keymap.set("n", "<leader>z", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
	end,
}
