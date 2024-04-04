local dap = require('dap')
local widgets = require('dap.ui.widgets')
local handle = io.popen("which python")
local python_path = handle:read("*a")
handle:close()
require('dap-python').setup(python_path)

table.insert(dap.configurations.python, {
  -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for more parameters
  type = 'python',
  request = 'launch',
  name = 'python current dir',
  program = '${file}',
  cwd = vim.fn.getcwd(),
})

table.insert(dap.configurations.python, {
  -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for more parameters
  type = 'python',
  request = 'launch',
  name = 'python current dir with args',
  program = '${file}',
  cwd = vim.fn.getcwd(),
  args = {
    '-linescan_paths',
    'mnt/c/Users/michele.valotti/Downloads/u Lens Line scan/20240320_122754_1E silicon line scan/BIN/-40 um/H10430_240320_130535_CH1_Regrid.bin,mnt/c/Users/michele.valotti/Downloads/u Lens Line scan/20240320_122754_1E silicon line scan/BIN/-40 um/H10430_240320_130535_CH1_Regrid.bin',
    '-linescan_dist_um','80',
    '-fast_scan_size_um','100',
    '-fast_scan_size_um','3.125',
  },
})

table.insert(dap.configurations.python, {
  -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for more parameters
  type = 'python',
  request = 'launch',
  name = 'python current dir (not justMyCode)',
  program = '${file}',
  cwd = vim.fn.getcwd(),
  justMyCode = false,
})

local function launch_wrapper(fn, opts)
  opts = opts or {}
  vim.api.nvim_command('write')
  local session_active = dap.session() ~= nil
  local repl_open = false
  for buf=1, vim.fn.bufnr('$') do
    local is_listed = vim.fn.buflisted(buf)==1
    if is_listed then
      local bufname = vim.api.nvim_buf_get_name(buf)
      local _, end_idx = string.find(bufname, '[dap-repl]')
      local is_repl = end_idx==string.len(bufname)
      if is_repl then
        local is_open = vim.fn.getbufinfo(buf)[1].hidden==0
        if is_open then
          repl_open = true
        end
      end
    end
  end
  if (not repl_open) and (not session_active) then
    dap.repl.open({height=20})
  end
  if opts == {} then
    fn()
  else
    fn(opts)
  end
end

vim.keymap.set('n', '<leader>dk', function() launch_wrapper(dap.continue) end)
vim.keymap.set('n', '<leader>dn', function() launch_wrapper(dap.continue, {new=true}) end)
vim.keymap.set('n', '<leader>dl', function() launch_wrapper(dap.run_last) end)
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>do', function() dap.step_over() end)
vim.keymap.set('n', '<leader>di', function() dap.step_into() end)
vim.keymap.set('n', '<leader>dK', function() vim.api.nvim_command('write'); dap.restart() end)
vim.keymap.set('n', '<leader>dt', function() dap.terminate() end)
vim.keymap.set('n', '<leader>dc', function() dap.repl.toggle({height=20}) end)
vim.keymap.set('n', '<leader>dS', function() widgets.cursor_float(widgets.sessions) end)
vim.keymap.set('n', '<leader>dF', function() dap.focus_frame() end)

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
