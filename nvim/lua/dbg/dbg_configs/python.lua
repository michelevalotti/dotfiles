local utils = require("utils")
local repl = require("dap.repl")
local python_configs = {}

table.insert(python_configs, {
    -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for more parameters
    type = 'python',
    request = 'launch',
    name = 'Python: Current File',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    pythonPath = 'python'
})

table.insert(python_configs, {
    type = 'python',
    request = 'launch',
    name = 'Python: Current File with args',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    args = function()
        local args_t = {}
        local s = vim.fn.input("enter --flag or value (or CR to start execution): ")
        while s ~= "" do
            table.insert(args_t, s)
            s = vim.fn.input("enter --flag or value (or CR to start execution): ")
        end
        return args_t
    end,
    pythonPath = 'python'
})

table.insert(python_configs, {
    type = 'python',
    request = 'launch',
    name = 'Python: Current File (not justMyCode)',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    justMyCode = false,
    pythonPath = 'python'
})

local function get_current_scope(path)
    local current_path = path or vim.fn.expand('%:p:h')
    local git_dir = utils.get_git_dir(current_path)
    git_dir = git_dir .. [[/]]
    git_dir = string.gsub(git_dir, [[-]], "_") -- cleanup of special chars

    current_path = path or vim.fn.expand('%:p')
    current_path = string.gsub(current_path, [[.py]], "")
    current_path = string.gsub(current_path, [[-]], "_")
    local path_no_git = string.gsub(current_path, git_dir, "")
    local scope_str = string.gsub(path_no_git, [[/]], [[.]])

    local nodes_table = utils.get_tree_chain()
    for i = #nodes_table, 1, -1 do
        scope_str = scope_str .. [[.]] .. nodes_table[i]
    end
    return scope_str
end


local function get_invoke_scope(path)
    local current_path = path or vim.fn.expand('%:p:h')
    local git_dir = utils.get_git_dir(current_path)
    git_dir = git_dir .. [[/]]
    git_dir = string.gsub(git_dir, [[-]], "_") -- cleanup of special chars

    current_path = path or vim.fn.expand('%:p')
    current_path = string.gsub(current_path, [[-]], "_")
    local inv_scope = string.gsub(current_path, git_dir, "")

    local nodes_table = utils.get_tree_chain()
    for i = #nodes_table, 1, -1 do
        inv_scope = inv_scope .. [[::]] .. nodes_table[i]
    end
    return inv_scope
end

table.insert(python_configs, {
    type = 'python',
    request = 'launch',
    name = 'Django Test: Current Scope',
    django = true,
    cwd = function()
        return utils.get_git_dir()
    end,
    program = "manage.py",
    args = function()
        return { 'test', get_current_scope() }
    end,
    pythonPath = 'python',
    justMyCode = false,
})

table.insert(python_configs, {
    type = 'python',
    request = 'launch',
    name = 'Invoke Test: Current Scope',
    module = 'invoke',
    cwd = function()
        return utils.get_git_dir()
    end,
    args = function()
        return { 'test', '--path', get_invoke_scope() }
    end,
    pythonPath = 'python',
    justMyCode = false,
    subProcess = true,
})

table.insert(python_configs, {
    type = 'python',
    request = 'launch',
    name = 'Django Test: User input scope',
    django = true,
    cwd = function()
        return utils.get_git_dir()
    end,
    program = "manage.py",
    args = function()
        local ret = { 'test' }
        local scope = vim.fn.input("Insert scope: ")
        table.insert(ret, scope)
        return ret
    end,
    pythonPath = 'python',
    justMyCode = false
})

table.insert(python_configs, {
    type = 'python',
    request = 'launch',
    name = 'Pytest: Current File',
    module = 'pytest',
    cwd = function()
        return utils.get_git_dir()
    end,
    args = { "${file}" },
    env = { PYTOHNPATH = "src" },
    justMyCode = false
})

return python_configs
