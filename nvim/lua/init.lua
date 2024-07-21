vim.g.fileformats = "dos"

vim.opt_global.fileformat = "dos"

vim.opt.termguicolors = true
vim.cmd.set "number"
vim.cmd.set "relativenumber"

vim.o.timeoutlen = 500  -- keystroke timeout for combined keybindings and whichkey (default is 1000)
vim.o.updatetime = 100  -- used by e.g. Coc highlight on hover
vim.o.signcolumn = "yes:1"  -- signcol always on and 1 char wide

vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.undofile = true  -- enable persistent undo (undo history files saved to vim.o.undodir which defaults to "$XDG_STATE_HOME/nvim/undo//")

-- autocmd to reload luafile on save (lazy config does not support reloading)
local lua_user_config = vim.api.nvim_create_augroup("lua_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {'*/nvim/**/*.lua'},
  group = lua_user_config,
  callback = function ()
    if vim.fn.expand('%:t@')~='lazy.lua' then
      vim.cmd('luafile %')
    end
  end,
  desc = 'source on save for nvim config .lua files (except unsupported lazy.lua)'
})

local tmux_config = vim.api.nvim_create_augroup("tmux_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {'.tmux.conf'},
  group = tmux_config,
  command = 'silent !tmux source-file %',
  desc = 'source .tmux.conf on save'
})
