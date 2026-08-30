require('vim._core.ui2').enable({
    enable = true,
    msg = {
        targets = {
            [''] = 'msg',
            empty = 'cmd',
            bufwrite = 'msg',
            confirm = 'dialog',
            emsg = 'pager',
            echo = 'msg',
            echomsg = 'msg',
            echoerr = 'msg',
            completion = 'cmd',
            list_cmd = 'pager',
            lua_error = 'pager',
            lua_print = 'msg',
            progress = 'msg',
            rpc_error = 'pager',
            quickfix = 'msg',
            search_cmd = 'msg',
            search_count = 'msg',
            shell_cmd = 'pager',
            shell_err = 'pager',
            shell_out = 'pager',
            shell_ret = 'msg',
            undo = 'msg',
            verbose = 'pager',
            wildlist = 'msg',
            wmsg = 'msg',
        },
        cmd = {
            height = 0.5,
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.3,
            timeout = 5000,
        },
        pager = {
            height = 0.5,
        },
    },
})

local msgs = require("vim._core.ui2.messages")
local ui2 = require("vim._core.ui2")
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(target)
    orig_set_pos(target)
    local win = ui2.wins and ui2.wins[target]
    if win and vim.api.nvim_win_is_valid(win) then
        if target == "pager" then
            vim.api.nvim_win_set_config(win, {
                relative = "editor",
                border = vim.o.winborder,
                style = "minimal",
                row = vim.o.lines - vim.api.nvim_win_get_height(win) - 2,
                col = vim.o.columns - vim.api.nvim_win_get_width(win) - 1,
            })
        end
    end
end
