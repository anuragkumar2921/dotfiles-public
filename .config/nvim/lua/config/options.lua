local opt = vim.opt

-- opt.cmdheight = 0
-- opt.showmode = true

-- block cursor instead of line cursor(Default)
opt.guicursor = ""
opt.showcmd = false

-- disable animation
vim.g.snacks_animate = false

vim.g.loaded_node_provider = 0 -- Disable node.js provider
vim.g.loaded_python3_provider = 0 -- Disable if not using Python plugins
vim.g.loaded_perl_provider = 0 -- Disable Perl provider
vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider

opt.number = false
opt.relativenumber = false

-- vim.o.winborder = "rounded"
