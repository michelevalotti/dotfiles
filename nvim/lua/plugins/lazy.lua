local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  'akinsho/toggleterm.nvim',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  { 'catppuccin/nvim', name = 'catppuccin'},
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
    dependencies = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'neovim/nvim-lspconfig'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
      {'saadparwaiz1/cmp_luasnip'},
      {'rafamadriz/friendly-snippets'},
      {'ray-x/lsp_signature.nvim'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'rcarriga/cmp-dap'},
      {'onsails/lspkind.nvim'},
    }
  },
  'RRethy/vim-illuminate',
  'folke/neodev.nvim',
  'mfussenegger/nvim-dap',
  'mfussenegger/nvim-dap-python',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  'nvim-telescope/telescope-dap.nvim',
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  'nvim-telescope/telescope-ui-select.nvim',
  'mbbill/undotree',
  'folke/which-key.nvim',
  'lewis6991/gitsigns.nvim',
  'tpope/vim-fugitive',
  'numToStr/Comment.nvim',
  'windwp/nvim-autopairs',
  {
    'echasnovski/mini.starter',
    branch = 'stable',
    dependencies = {
      { 'echasnovski/mini.nvim', branch = 'stable' },
      { 'echasnovski/mini.sessions', branch = 'stable' }
    }
  },
  'AckslD/nvim-neoclip.lua',
  'kylechui/nvim-surround',
  'stevearc/oil.nvim',
  {
    'refractalize/oil-git-status.nvim',
    dependencies = { 'oil.nvim' },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
})
