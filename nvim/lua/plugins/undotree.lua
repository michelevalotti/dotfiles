local opts = { noremap=true, silent=true}
vim.keymap.set('n', '<leader>ut', ':UndotreeToggle<CR>', opts)
vim.keymap.set('n', '<leader>uf', ':UndotreeFocus<CR>', opts)
vim.keymap.set('n', '<leader>us', ':UndotreeShow<CR>', opts)
vim.keymap.set('n', '<leader>uh', ':UndotreeHide<CR>', opts)

vim.g.undotree_WindowLayout = 4
