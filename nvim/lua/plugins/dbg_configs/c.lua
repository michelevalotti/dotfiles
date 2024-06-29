local c_configs = {}

table.insert(c_configs, {
  name = "Launch",
  type = "cppdbg",
  request = "launch",
  program = function ()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  end,
  cwd = "${workspaceFolder}",
  stopAtEntry = false,
})


table.insert(c_configs, {
  name = "Launch with args",
  type = "cppdbg",
  request = "launch",
  program = function ()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  end,
  cwd = "${workspaceFolder}",
  stopAtEntry = false,
  args = function()
    local args_t = {}
    local s = vim.fn.input("enter --flag or value (or CR to start execution): ")
    while s ~= "" do
      table.insert(args_t,s)
      s = vim.fn.input("enter --flag or value (or CR to start execution): ")
    end
    return args_t
  end,
})

return c_configs
