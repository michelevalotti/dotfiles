vim.o.cmdheight = 0

require("tiny-cmdline").setup({
    native_types = {},
    menu_col_offset = 0,
    width = {
        fraction = 0.3,  -- fraction of editor columns (0–1)
        min = 40,        -- minimum width in columns
        max = 60,        -- maximum width in columns
    },
    title = {
        enabled = true,
    },
})
