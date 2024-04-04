local opts = { noremap = true, silent = true}
local term_opts = { silent = true }
local keymap = vim.keymap.set

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>p", "<C-^>", opts)  -- switch to previous buffer

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- easier :cnext and :cprevious
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprevious<CR>", opts)

-- pane creation like tmux
keymap("n", "<leader>\\", ":rightbelow vnew<CR>", opts)
keymap("n", "<leader>-", ":rightbelow new<CR>", opts)

-- copy buffer path
keymap("n", "<leader>cp", ':let @" = expand("%:p")<CR>', opts)

-- convenience for diffview (merge conflict resolution)
keymap("n", "<leader>hP", ':diffput<CR>', opts)
keymap("n", "<leader>hgh", ':diffget /:2<CR>', opts)  -- /:2 is pattern that should only be in lhs diff buffer (bit hacky)
keymap("n", "<leader>hgl", ':diffget /:3<CR>', opts)

-- Insert --
-- Press jk fast to exit insert mode 
keymap("i", "jk", "<Esc>", opts)
keymap("i", "kj", "<Esc>", opts)

-- no arrow navigation in insert
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-k>", "<Up>", opts)
keymap("i", "<C-l>", "<Right>", opts)
