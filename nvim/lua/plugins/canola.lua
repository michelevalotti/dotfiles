local utils = require("utils")
vim.g.canola = {
    highlights = { columns = false },
    columns = {
        "git_status",
        { name = "size",        highlight = "NonText" },
        { name = "mtime",       format = "%Y-%m-%d %H:%M:%S" },
        { name = "permissions", highlight = "NonText" },
        { name = "icon" },
    },
    hidden = {
        enabled = false,
    },
    keymaps = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["<C-s>"] = false,
        ["<C-f>"] = "actions.refresh",
    },
}

vim.api.nvim_set_hl(0, "CanolaDir", { link = "Directory" })
vim.api.nvim_set_hl(0, "CanolaDate", { link = "NonText" })

vim.g.canola_git = {
    show = { untracked = true, ignored = true },
    format = 'porcelain',
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>od', require("canola").toggle,
    utils.tbl_extend(opts, { desc = "Open Canola in current buffer dir" }))
vim.keymap.set('n', '<leader>or', require("canola.actions").refresh.callback,
    utils.tbl_extend(opts, { desc = "Refresh Canola buffer" }))
