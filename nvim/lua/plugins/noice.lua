local noice = require('noice')
noice.setup({
  presets = {
    long_message_to_split = true, -- long messages will be sent to a split
  },
  lsp = {
    hover = { enabled = false },
    signature = { enabled = false },
    progress = { enabled = false },
    message = { enabled = false },
    smart_move = { enabled = false },
  },
})

vim.keymap.set("c", "<C-e>", function()
  noice.redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

vim.opt.showmode = false  -- only show recording messages in lualine (not insert/visual mode)
require("lualine").setup({
  sections = {
    lualine_x = {
      {
        noice.api.statusline.mode.get,
        cond = noice.api.statusline.mode.has,
        color = { fg = "#ff9e64" },
      },
      'encoding',
      'fileformat',
      'filetype',
    },
  },
})
require("telescope").load_extension("noice")
