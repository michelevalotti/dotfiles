-- autocmd to reload luafile on save (lazy config does not support reloading)
local lua_user_config = vim.api.nvim_create_augroup("lua_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { '*/nvim/**/*.lua' },
    group = lua_user_config,
    callback = function()
        vim.notify("Reloading " .. vim.fn.expand('%:t'))
        vim.cmd('luafile %')
    end,
    desc = 'source on save for nvim config .lua files'
})

local tmux_config = vim.api.nvim_create_augroup("tmux_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { '.tmux.conf' },
    group = tmux_config,
    command = 'silent !tmux source-file %',
    desc = 'source .tmux.conf on save'
})
