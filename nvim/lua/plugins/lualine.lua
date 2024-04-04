local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

require('lualine').setup({
  options = {
    theme = "catppuccin",
    disabled_filetypes = {'starter'}
  },
  sections = {
    lualine_b = { 'branch', {'diff', source = diff_source}, 'diagnostics' },
    lualine_c = { '%f%m' },
  },
  extensions = { 'toggleterm' },
})
