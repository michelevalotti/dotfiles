local mini_sessions = require('mini.sessions')
local action_state = require('telescope.actions.state')
require('mini.sessions').setup({
  -- Whether to read latest session if Neovim opened without file arguments
  autoread = false,
  -- Whether to write current session before quitting Neovim
  autowrite = true,
  -- Directory where global sessions are stored (use `''` to disable)
  directory =  '~/.config/nvim/sessions',
  -- File for local session (use `''` to disable)
  file = 'Session.vim',
})
vim.keymap.set('n', '<leader>ss', mini_sessions.select, {noremap=true, silent=true})
vim.keymap.set('n', '<leader>sm', function ()
  local session_name = vim.fn.input('session file name: ')
  if session_name == "" then
    return
  end
  mini_sessions.write(session_name)
end, {noremap=true})
vim.keymap.set('n', '<leader>sd', function ()
  mini_sessions.select('delete')
end, {noremap=true})


local header_art = 
[[
 ╭──╮  ╭┬────╮╭─────╮┬   ┬┬╭──┬──╮
 │  │  ││     │     ││   │││  │  │
 │  │  ││     │     ││   │││  │  │
 │  │  │├──┤  │     │╰┐ ┌╯││  │  │
 │  │  ││     │     │ │ │ ││  │  │
 │  │  ││     │     │ │ │ ││  │  │
 ╯  ╰──╯╰────╯╰─────╯ ╰─╯ ┴┴     ┴
]]  -- it looks wonky here but renders perfectly on the splashscreen
require('mini.starter').setup({
  header = header_art,
})
