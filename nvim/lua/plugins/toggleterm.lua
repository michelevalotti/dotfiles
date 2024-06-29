local tt = require('toggleterm')
tt.setup({
  close_on_exit = false,
  shade_terminals = true,
  shade_filetypes = {},
  shading_factor = 2,
  open_mapping = [[\\]],
  insert_mappings = false,
  terminal_mappings = true,
  direction = 'float',
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  winbar = {
    enabled = true,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
})

vim.keymap.set('n', '\\ts', ':TermSelect<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '\\ch', ':ToggleTerm<CR>:ToggleTerm direction=horizontal<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '\\cv', ':ToggleTerm<CR>:ToggleTerm direction=vertical<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '\\cf', ':ToggleTerm<CR>:ToggleTerm direction=float<CR>', { noremap = true, silent = true})
vim.keymap.set("n", "\\p", ":w | TermExec cmd='python \"%:p\"'<CR>", { noremap = true, silent = true, desc = 'python execute current file' })

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts) -- remapping to escape terminal
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'kj', [[<C-\><C-n>]], opts)
end
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
