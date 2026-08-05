vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.colorscheme("catppuccin")
-- Bootstrap lazy.nvim
require("config.lazy")

-- Load configurations
require("config.options")
require("config.keymaps")
require("config.autocmds")
