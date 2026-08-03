-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

-- keymap shortcuts
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- navigation zz shortcuts
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- cut (x) without storing it to register
keymap.set("n", "x", '"_x')

-- paste without storing it into register
keymap.set("x", "<leader>p", [["_dP]])

-- <leader><C-a> to increment the number.
-- By default, C-a is the shortcut. Since, tmux prefix is C-a, its coliding
-- Increment/decrement
keymap.set({ "n", "v" }, "+", "<C-a>")
keymap.set({ "n", "v" }, "-", "<C-x>")

-- increment/ decrement the size of window
-- Resize window using arrow keys
keymap.set("n", "<Up>", ":resize +2<CR>", opts)
keymap.set("n", "<Down>", ":resize -2<CR>", opts)
keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)
keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)

-- Remove the conflicting lazy mapping
vim.keymap.del("n", "<leader>l")
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
-- Leetcode keymaps
vim.keymap.set("n", "<leader>l'", ":Leet run<CR>", opts)
vim.keymap.set("n", "<leader>l<CR>", ":Leet submit<CR>", opts)
vim.keymap.set("n", "<leader>lc", ":Leet console<CR>", opts)
vim.keymap.set("n", "<leader>lh", ":Leet hints<CR>", opts)

-- paste content to the next line
keymap.set("n", "<C-p>", "o<Esc>p", opts)

-- tabs
-- leader key is important as ctrl+i and tab behaves same
keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader><tab><tab>", "g<tab>", { desc = "go to Last visited Tab" })
keymap.set("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "go to Next Tab" })
keymap.set("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "go to Previous Tab" })
keymap.set(
	"n",
	"<leader><tab>g",
	"<cmd>tab split | lua vim.lsp.buf.definition()<CR>",
	{ desc = "Open defination in new tab" }
)

local function toggle_wrap(wrapper)
	local mode = vim.fn.mode()

	if mode == "n" then
		local line = vim.api.nvim_get_current_line()
		local wlen = #wrapper
		local wrapped = #line >= wlen * 2 and line:sub(1, wlen) == wrapper and line:sub(-wlen) == wrapper
		-- Guard: single * should not match **bold**
		if wrapped and wrapper == "*" and line:sub(1, 2) == "**" and line:sub(-2) == "**" then
			wrapped = false
		end

		if wrapped then
			vim.api.nvim_set_current_line(line:sub(wlen + 1, -wlen - 1))
		else
			vim.api.nvim_set_current_line(wrapper .. line .. wrapper)
		end
	elseif mode == "v" or mode == "V" or mode == "\22" then
		vim.cmd("normal! \027")
		if mode == "V" then
			vim.cmd("'<,'>s/^/" .. wrapper .. "/")
			vim.cmd("'<,'>s/$/" .. wrapper .. "/")
		else
			vim.cmd("normal! `>a" .. wrapper)
			vim.cmd("normal! `<i" .. wrapper)
		end
	end
end

keymap.set({ "n", "v" }, "<leader>mb", function()
	toggle_wrap("**")
end, { desc = "Toggle bold (line or selection)" })

keymap.set({ "n", "v" }, "<leader>mi", function()
	toggle_wrap("*")
end, { desc = "Toggle italic (line or selection)" })

keymap.set({ "n", "v" }, "<leader>ms", function()
	toggle_wrap("~~")
end, { desc = "Toggle strikethrough (line or selection)" })

-- remap to nothing
vim.keymap.set("n", "<S-h>", "<Nop>", { noremap = true })
vim.keymap.set("n", "<S-l>", "<Nop>", { noremap = true })
vim.keymap.set("n", "<leader>,", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "x" }, "s", "<Nop>", { noremap = true, silent = true })

-- setting default terminal keymaps
vim.keymap.set({ "n", "t" }, "<c-_>", function()
	Snacks.terminal.toggle()
end, { desc = "Toggle Terminal" })

vim.keymap.set("n", "<leader>mnt", function()
	local name
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed

	for s, inner, e in line:gmatch("()%[%[([^%]]+)%]%]()") do
		if col >= s and col < e then
			name = inner
			break
		end
	end

	-- fall back to prompt if cursor isn't on a wikilink
	local function create(n)
		if not n or n == "" then
			return
		end
		n = n:gsub("%.md$", "")
		n = n:gsub("|.*$", "")

		local root = vim.fs.root(0, { ".git", ".marksman.toml" }) or vim.fn.getcwd()
		local dir = root .. "/3 - tags"
		vim.fn.mkdir(dir, "p")

		local path = dir .. "/" .. n .. ".md"
		if vim.fn.filereadable(path) == 0 then
			vim.fn.writefile({ "# " .. n, "" }, path)
		end
		vim.cmd.edit(path)
	end

	if name then
		create(name)
	else
		vim.ui.input({ prompt = "Tag note name: " }, create)
	end
end, { desc = "New tag note" })

keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

local window_cmds = {
	v = "Split Window Right",
	s = "Split Window Below",
	o = "Close Other Windows",
	q = "Quit Window",
	x = "Swap Window",
}

for key, desc in pairs(window_cmds) do
	vim.keymap.set("n", "<leader>w" .. key, "<C-w>" .. key, { desc = desc })
end
