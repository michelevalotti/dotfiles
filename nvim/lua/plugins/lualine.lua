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
    disabled_filetypes = {'starter'},
    component_separators = '￨',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'branch', {'diff', source = diff_source}, 'diagnostics' },
    lualine_c = { '%f%m' },
    lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
  },
  extensions = { 'toggleterm' },
})
