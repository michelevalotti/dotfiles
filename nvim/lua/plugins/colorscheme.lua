require("catppuccin").setup({
  flavour = "latte",
  dim_inactive = {
    enabled = true, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.5, -- percentage of the shade to apply to the inactive window
  },
  integrations = {
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    mason = true,
    which_key = true,
    telescope = {
      enabled = false,
    },
  }
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
