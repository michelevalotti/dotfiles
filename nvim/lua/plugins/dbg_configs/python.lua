local python_configs = {}

table.insert(python_configs, {
  -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for more parameters
  type = 'python',
  request = 'launch',
  name = 'python current dir',
  program = '${file}',
  cwd = vim.fn.getcwd(),
  pythonPath = 'python'
})

table.insert(python_configs, {
  type = 'python',
  request = 'launch',
  name = 'python current dir with args',
  program = '${file}',
  cwd = vim.fn.getcwd(),
  args = function()
    local args_t = {}
    local s = vim.fn.input("enter --flag or value (or CR to start execution): ")
    while s ~= "" do
      table.insert(args_t,s)
      s = vim.fn.input("enter --flag or value (or CR to start execution): ")
    end
    return args_t
  end,
  pythonPath = 'python'
})

table.insert(python_configs, {
  type = 'python',
  request = 'launch',
  name = 'python current dir (not justMyCode)',
  program = '${file}',
  cwd = vim.fn.getcwd(),
  justMyCode = false,
  pythonPath = 'python'
})

return python_configs
