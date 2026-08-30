vim.opt.termguicolors = true
vim.cmd.set "number"
vim.cmd.set "relativenumber"

vim.o.timeoutlen = 500     -- keystroke timeout for combined keybindings and whichkey (default is 1000)
vim.o.updatetime = 100     -- interval in ms for CursorHold event (and for writing swap file)
vim.o.signcolumn = "yes:1" -- signcol always on and 1 char wide
vim.o.scrolloff = 5        -- keep 5 lines below and above cursor (except at top or bottom of file)

vim.o.cursorline = false
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.undofile = true -- enable persistent undo (undo history files saved to vim.o.undodir which defaults to "$XDG_STATE_HOME/nvim/undo//")
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.nrformats = "unsigned" -- ctrl-a and ctrl-x act on absolute values

vim.o.list = true     -- use special characters to represent things like tabs or trailing spaces
vim.opt.listchars = { -- NOTE: using `vim.opt` instead of `vim.o` to pass rich object
    leadmultispace = "▏   ",
    trail = "·",
    extends = "»",
    precedes = "«",
    tab = "> "
}
vim.opt.fillchars = { eob = " " }

vim.o.laststatus = 3        -- one statusline at the bottom of the window
vim.o.winborder = "rounded" -- some plugins don't implement this properly yet, keep this as rounded for now
vim.o.pumborder = "rounded"

require("keymaps")          -- require first so all mappings (including leader) are set up properly
require("autocommands")
require("plugins.pack")     -- this requires all the other plugins too (require before statusline/winbar so colors are set up)

vim.g.sessions_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "sessions")
vim.go.statusline = '%{%v:lua.require("statusline").render_statusline()%}'
vim.go.winbar = '%{%v:lua.require("statusline").render_winbar()%}'
vim.g.catppuccin_flavour = "latte"
