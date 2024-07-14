local oil = require('oil')
local oil_util = require('oil.util')
local opts = {noremap = true, silent = true}

vim.g.oilDirpathOnExit = nil
local function setPathGlobalVarOnExit ()
  vim.g.oilDirpathOnExit = oil.get_current_dir()
  oil.close()
end
local function setPathGlobalVarOnFloatToggleExit (dir)
  if oil_util.is_oil_bufnr(0) then
    vim.g.oilDirpathOnExit = oil.get_current_dir()
  end
  oil.toggle_float(dir)
end
local function setPathGloablVarOnSelect()
  vim.g.oilDirpathOnExit = oil.get_current_dir()
  oil.select()
end
local function OilToggle(dir)
  if oil_util.is_oil_bufnr(0) then
    setPathGlobalVarOnExit()
  else
    oil.open(dir)
  end
end

oil.setup({
  columns = {
    { "size", highlight = "NonText" },
    { "mtime", format = "%Y-%m-%d %H:%M:%S", highlight = "NonText"  },
    { "permissions", highlight = "NonText"  },
    { "icon", highlight = "NonText"  },
  },
  win_options = {
    signcolumn = 'yes:2',
  },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["<C-c>"] = { callback = setPathGlobalVarOnExit, desc = "Close oil and restore original buffer" },
    ["<CR>"] = { callback = setPathGloablVarOnSelect, desc = "Open the entry under the cursor" },
    ["<C-l>"] = false,
    ["<C-h>"] = false,
    ["<C-s>"] = false,
    ["<C-f>"] = "actions.refresh",
    ["<C-->"] = "actions.select_split",
    ["<C-\\>"] = "actions.select_vsplit",
  }
})

vim.keymap.set('n', '<leader>oD', function() setPathGlobalVarOnFloatToggleExit(oil.get_current_dir()) end, opts)
vim.keymap.set('n', '<leader>oB', function() setPathGlobalVarOnFloatToggleExit(vim.loop.cwd()) end, opts)
vim.keymap.set('n', '<leader>od', function() OilToggle(oil.get_current_dir()) end, opts)
vim.keymap.set('n', '<leader>ob', function() OilToggle(vim.loop.cwd()) end, opts)

local function openLastDirIfAvailable(oil_open_fn)
  local openDir
  if vim.g.oilDirpathOnExit == nil then
    openDir = oil.get_current_dir()
  else
    openDir = vim.g.oilDirpathOnExit
  end
  oil_open_fn(openDir)
end

vim.keymap.set('n', '<leader>oP', function() openLastDirIfAvailable(setPathGlobalVarOnFloatToggleExit) end, opts)
vim.keymap.set('n', '<leader>op', function() openLastDirIfAvailable(OilToggle) end, opts)

require('oil-git-status').setup()
