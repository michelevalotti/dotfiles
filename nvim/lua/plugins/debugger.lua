local dap = require('dap')
dap.defaults.fallback.terminal_win_cmd = 'tabnew'

local utils = require('utils')
local configs_dir = vim.api.nvim_get_runtime_file("lua/dbg", false)[1]
for _, adapter_name in ipairs(utils.list_dir(configs_dir .. '/dbg_adapters') or {}) do
    adapter_name = string.sub(adapter_name, 1, -5)
    dap.adapters[adapter_name] = require('dbg.dbg_adapters.' .. adapter_name)
end
for _, config_name in ipairs(utils.list_dir(configs_dir .. '/dbg_configs') or {}) do
    config_name = string.sub(config_name, 1, -5)
    dap.configurations[config_name] = require('dbg.dbg_configs.' .. config_name)
end

vim.keymap.set('n', '<leader>dk', dap.continue, { desc = "Debugger Continue" })
vim.keymap.set('n', '<leader>dn', function() dap.continue({ new = true }) end,
    { desc = "Start additional debugging session" })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = "Debugger Run Last Session" })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = "Debugger Step Over" })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = "Debugger Step Into" })
vim.keymap.set('n', '<F12>', dap.step_over, { desc = "Debugger Step Over" })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Debugger Step Into" })
vim.keymap.set('n', '<leader>dK', function()
    vim.api.nvim_command('write'); dap.restart()
end, { desc = "Debugger Restart" })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = "Debugger Terminate" })
vim.keymap.set('n', '<leader>dS',
    function()
        local widgets = require("dap.ui.widgets")
        widgets.cursor_float(widgets.sessions)
    end,
    { desc = "List running sessions" })
vim.keymap.set('n', '<leader>dF', dap.focus_frame, { desc = "Focus on current active session" })

vim.keymap.set({ 'n', 'v' }, '<Leader>df',
    function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
    end,
    { desc = "Debugger Open Scopes in Floating Window" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dh',
    function()
        require("dap.ui.widgets").hover(nil)
    end,
    { desc = "Debugger Open Hover Window" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-float",
    callback = function() vim.keymap.set('n', 'q', ':q<CR>', { silent = true, buffer = true }) end,
})

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', {
    text = '',
    texthl = 'DapUIBreakpointsDisabledLine',
    linehl = '',
    numhl =
    ''
})

dap.listeners.after['event_exited']['close_repl'] = function()
    local n_sessions = 0
    for _ in pairs(dap.sessions()) do n_sessions = n_sessions + 1 end
    if n_sessions <= 1 then
        require("dap-view").close()
    end
end

dap.listeners.after['event_initialized']['open_repl'] = function()
    vim.api.nvim_command('write')
    local dap_view = require("dap-view")
    if package.loaded["dap-view"] == nil then
        dap_view.setup({
            winbar = {
                default_section = "repl",
            },
            windows = {
                size = 20,
                position = "below",
            },
        })
    end
    dap_view.open()
end

vim.keymap.set('n', '<Leader>dv', function() require("dap-view").toggle() end, { desc = "Toggle Dap View" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dw', function() require("dap-view").add_expr() end,
    { desc = "Watch expression under cursor or visual selection" })

vim.keymap.set("x", "<leader>di", function()
    local lines = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
    dap.repl.open()
    dap.repl.execute(table.concat(lines, "\n"))
end, { desc = "Evaluate visual selection in REPL" })
