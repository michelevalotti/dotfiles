local utils = require("utils")
local opts = { noremap = true, silent = true }
local search_opts = { noremap = true } -- not silent no search menu is surfaced
local keymap = vim.keymap.set

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Easier window navigation
keymap("n", "<C-h>", "<C-w>h", utils.tbl_extend(opts, { desc = "Move window focus left" }))
keymap("n", "<C-j>", "<C-w>j", utils.tbl_extend(opts, { desc = "Move window focus down" }))
keymap("n", "<C-k>", "<C-w>k", utils.tbl_extend(opts, { desc = "Move window focus up" }))
keymap("n", "<C-l>", "<C-w>l", utils.tbl_extend(opts, { desc = "Move window focus right" }))

-- Navigate buffers
keymap("n", "<M-l>", ":bnext<CR>", opts)
keymap("n", "<M-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>p", "<C-^>", utils.tbl_extend(opts, { desc = "Switch to Previous Buffer" })) -- switch to previous buffer

-- Navigate tabs
keymap("n", "<leader>tc", ":tabclose<CR>", utils.tbl_extend(opts, { desc = "Close tab" })) -- gt and gT for next/prev tab

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- easier :cnext and :cprevious
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprevious<CR>", opts)

-- pane creation like tmux
keymap("n", "<leader>\\", ":rightbelow vnew<CR>", utils.tbl_extend(opts, { desc = "New empty buffer to the right" })) -- split buffer
keymap("n", "<leader>-", ":rightbelow new<CR>", utils.tbl_extend(opts, { desc = "New empty buffer below" }))
keymap("n", "<leader>sh", ":leftabove vnew<CR>", utils.tbl_extend(opts, { desc = "New empty buffer to the left" }))
keymap("n", "<leader>sk", ":leftabove new<CR>", utils.tbl_extend(opts, { desc = "New empty buffer above" }))
keymap("n", "<leader>Sl", ":botright vnew<CR>", utils.tbl_extend(opts, { desc = "New empty window to the right" })) -- split window
keymap("n", "<leader>Sj", ":botright new<CR>", utils.tbl_extend(opts, { desc = "New empty window below" }))
keymap("n", "<leader>Sh", ":topleft vnew<CR>", utils.tbl_extend(opts, { desc = "New empty window to the left" }))
keymap("n", "<leader>Sk", ":topleft new<CR>", utils.tbl_extend(opts, { desc = "New empty window above" }))

-- copy buffer path to system clipboard
keymap("n", "<leader>cp", ':let @+ = expand("%:p")<CR>',
    utils.tbl_extend(opts, { desc = "Copy full path of current buffer into system clipboard" }))

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<Esc>", opts)
keymap("i", "kj", "<Esc>", opts)

-- no arrow navigation in insert
keymap("i", "<C-h>", "<Left>", utils.tbl_extend(opts, { desc = "Move cursor left" }))
keymap("i", "<C-j>", "<Down>", utils.tbl_extend(opts, { desc = "Move cursor down" }))
keymap("i", "<C-k>", "<Up>", utils.tbl_extend(opts, { desc = "Move cursor up" }))
keymap("i", "<C-l>", "<Right>", utils.tbl_extend(opts, { desc = "Move cursor right" }))

-- Terminal --
-- exit terminal-mode with esc
keymap("t", "<Esc>", "<C-\\><C-n>", opts)


-- Visual --
local function search_special_terms(cmd_pre, cmd_post)
    cmd_pre = cmd_pre or ""
    cmd_post = cmd_post or ""
    vim.cmd('normal! "zy')
    local selection = vim.fn.getreg('z')
    local escaped = vim.fn.escape(selection, [[/\.^$*]])
    vim.api.nvim_feedkeys(cmd_pre .. escaped .. cmd_post, "n", false)
end
keymap("v", "/", function() search_special_terms("/") end,
    utils.tbl_extend(search_opts, { desc = "Find visual selection" }))
-- keymap("v", "<leader>r", "y:%s/<C-r>0//g<Left><Left>", search_opts)
local tleft = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
keymap("v", "<leader>r", function() search_special_terms(":%s/", "//g" .. tleft .. tleft) end,
    utils.tbl_extend(search_opts, { desc = "Find and replace visual selection" }))
