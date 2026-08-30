require("arborist").setup({
    ignore = { "canola" },
    disable = {
        highlight = { "csv" }, -- keeps rainbow column highlighting
    },
})

local treesitter_context = require('treesitter-context')
treesitter_context.setup({
    enable = true,
    multiwindow = true,
    separator = nil,      -- single char or nil to remove
    mode = "topline",     -- cursor or topline
    trim_scope = "outer", -- outer or inner
})

vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "NONE" })
vim.api.nvim_set_hl(0, "TreesitterContext",
    {
        bg = vim.api.nvim_get_hl(0, { name = "TabLine" })["bg"],
    })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber",
    {
        fg = vim.api.nvim_get_hl(0, { name = "LineNr" })["fg"],
        bg = vim.api.nvim_get_hl(0, { name = "TreesitterContext" })["bg"],
    })

vim.keymap.set("n", "[C", function()
    treesitter_context.go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump to context upwards" })
vim.keymap.set("n", "[V", function()
    treesitter_context.go_to_context(-1)
end, { silent = true, desc = "Jump to top of context" })
