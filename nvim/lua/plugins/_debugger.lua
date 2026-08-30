local dap = require('dap')

_G.debug_mode_active = false

local exit_debug_mode = function()
    if not _G.debug_mode_active then
        return
    end
    _G.debug_mode_active = false
    local normal_keys = { 'v', 'c', 'n', 'l', 'b', 'o', 'i', 'K', 't', 'S', 'F', '<Esc>' }
    local visual_and_normal_keys = { 'w', 'f', 'h' }
    for _, key in ipairs(normal_keys) do
        vim.keymap.del('n', key)
    end
    for _, key in ipairs(visual_and_normal_keys) do
        vim.keymap.del({ 'n', 'v' }, key)
    end
    vim.keymap.del('x', 'i')
    vim.cmd("redrawstatus") -- update statusline
end

local enter_debug_mode = function()
    if _G.debug_mode_active then
        return
    end
    _G.debug_mode_active = true

    vim.keymap.set('n', 'v', function() require("dap-view").toggle() end, { desc = "Toggle Dap View" })
    vim.keymap.set({ 'n', 'v' }, 'w', function() require("dap-view").add_expr() end,
        { desc = "Watch expression under cursor or visual selection" })
    vim.keymap.set("x", "i", function()
        local lines = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
        dap.repl.open()
        dap.repl.execute(table.concat(lines, "\n"))
    end, { desc = "Evaluate visual selection in REPL" })
    vim.keymap.set('n', 'c', dap.continue, { desc = "Debugger Continue" })
    vim.keymap.set('n', 'n', function() dap.continue({ new = true }) end,
        { desc = "Start additional debugging session" })
    vim.keymap.set('n', 'l', dap.run_last, { desc = "Debugger Run Last Session" })
    vim.keymap.set('n', 'b', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set('n', 'o', dap.step_over, { desc = "Debugger Step Over" })
    vim.keymap.set('n', 'i', dap.step_into, { desc = "Debugger Step Into" })
    vim.keymap.set('n', 'K', function()
        vim.api.nvim_command('write'); dap.restart()
    end, { desc = "Debugger Restart" })
    vim.keymap.set('n', 't', dap.terminate, { desc = "Debugger Terminate" })
    vim.keymap.set('n', 'S',
        function()
            local widgets = require("dap.ui.widgets")
            widgets.cursor_float(widgets.sessions)
        end,
        { desc = "List running sessions" })
    vim.keymap.set('n', 'F', dap.focus_frame, { desc = "Focus on current active session" })
    vim.keymap.set({ 'n', 'v' }, 'f',
        function()
            local widgets = require("dap.ui.widgets")
            widgets.centered_float(widgets.scopes)
        end,
        { desc = "Debugger Open Scopes in Floating Window" })
    vim.keymap.set({ 'n', 'v' }, 'h',
        function()
            require("dap.ui.widgets").hover(nil)
        end,
        { desc = "Debugger Open Hover Window" })
    vim.keymap.set('n', '<Esc>', exit_debug_mode)

    vim.cmd("redrawstatus") -- update statusline
end

vim.keymap.set('n', '<leader>d', enter_debug_mode, { desc = "Enter debug mode" } )
