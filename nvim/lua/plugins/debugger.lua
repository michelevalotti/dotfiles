local dap = require('dap')
local widgets = require('dap.ui.widgets')
local mason_dap = require('mason-nvim-dap')
dap.defaults.fallback.terminal_win_cmd = 'tabnew'

mason_dap.setup({
  automatic_setup = true,
  handlers = {
    function(config)
      mason_dap.default_setup(config)
    end,
    python = function(config)
      config.configurations = require('plugins.dbg_configs.python')
      mason_dap.default_setup(config)
    end,
    cppdbg = function(config)
      config.configurations = require('plugins.dbg_configs.c')
      mason_dap.default_setup(config)
    end,
  },
  ensure_installed = {},
  automatic_installation = false,
})

vim.keymap.set('n', '<leader>dk', dap.continue)
vim.keymap.set('n', '<leader>dn', function() dap.continue({new=true}) end)
vim.keymap.set('n', '<leader>dl', dap.run_last)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>do', dap.step_over)
vim.keymap.set('n', '<leader>di', dap.step_into)
vim.keymap.set('n', '<leader>dK', function() vim.api.nvim_command('write'); dap.restart() end)
vim.keymap.set('n', '<leader>dt', dap.terminate)
vim.keymap.set('n', '<leader>dc', function() dap.repl.toggle({height=20}) end)
vim.keymap.set('n', '<leader>dS', function() widgets.cursor_float(widgets.sessions) end)
vim.keymap.set('n', '<leader>dF', dap.focus_frame)

vim.api.nvim_create_autocmd( "FileType", {
  pattern = "dap-float",
  callback = function() vim.keymap.set('n', 'q', ':q<CR>', {silent=true, buffer=true}) end,
})

local sb = widgets.sidebar(widgets.scopes, {height=20}, "belowright 20split")
vim.keymap.set({'n', 'v'}, '<Leader>ds', function()
  sb.toggle()
end)
vim.keymap.set({'n', 'v'}, '<Leader>df', function()
  widgets.centered_float(widgets.scopes)
end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  widgets.hover()
end)

dap.listeners.after['event_exited']['close_repl'] = function ()
  local n_sessions = 0
  for _ in pairs(dap.sessions()) do n_sessions = n_sessions + 1 end
  if n_sessions <= 1 then
    dap.repl.close()
  end
end

dap.listeners.after['event_initialized']['open_repl'] = function ()
  vim.api.nvim_command('write')
  dap.repl.open({height=20})
end

local gt_bp = require('goto-breakpoints')
vim.keymap.set('n', ']b', gt_bp.next, {desc = 'Next breakpoint'})
vim.keymap.set('n', '[b', gt_bp.prev, {desc = 'Previous breakpoint'})
vim.keymap.set('n', ']S', gt_bp.stopped, {desc = 'Go to stopped debug line'})
