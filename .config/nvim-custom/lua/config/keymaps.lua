-- lua/config/keymaps.lua
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Visual mode line movement (your custom keymaps)
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Navigation zz shortcuts
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- Cut (x) without storing it to register
keymap.set("n", "x", '"_x')

-- Paste without storing it into register
keymap.set("x", "<leader>p", [["_dP]])

-- Increment/decrement (changed from C-a due to tmux conflict)
keymap.set({ "n", "v" }, "+", "<C-a>")
keymap.set({ "n", "v" }, "-", "<C-x>")

-- Window resize using arrow keys
keymap.set("n", "<Up>", ":resize +2<CR>", opts)
keymap.set("n", "<Down>", ":resize -2<CR>", opts)
keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)
keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)

-- Remove the conflicting lazy mapping and set new one (safe deletion)
pcall(vim.keymap.del, "n", "<leader>l")
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Leetcode keymaps
vim.keymap.set("n", "<leader>l'", ":Leet run<CR>", opts)
vim.keymap.set("n", "<leader>l<CR>", ":Leet submit<CR>", opts)
vim.keymap.set("n", "<leader>lc", ":Leet console<CR>", opts)
vim.keymap.set("n", "<leader>lh", ":Leet hints<CR>", opts)

-- Paste content to the next line
keymap.set("n", "<C-p>", "o<Esc>p", opts)

-- Tab management (leader key is important as ctrl+i and tab behaves same)
keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap.set("n", "<leader><tab><tab>", "g<tab>", { desc = "go to Last visited Tab" })
keymap.set("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "go to Next Tab" })
keymap.set("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "go to Previous Tab" })
keymap.set(
	"n",
	"<leader><tab>g",
	"<cmd>tab split | lua vim.lsp.buf.definition()<CR>",
	{ desc = "Open defination in new tab" }
)

-- Window management (you mentioned <leader>w<q,v,s>)
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>wq", "<cmd>close<CR>", { desc = "Close current split" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })

-- Quit Neovim
keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit Neovim" })

keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
