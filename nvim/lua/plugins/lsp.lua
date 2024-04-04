local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspsaga = require('lspsaga')
local lspkind = require('lspkind')
require('luasnip.loaders.from_vscode').lazy_load()

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false,
    exclude = {'gr','<F2>','<F3>','gd'},  -- remapped elsewhere
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, {buffer = bufnr}),
    vim.keymap.set({'n', 'v'}, 'gF', function() vim.lsp.buf.format({async=true}) end, {buffer = bufnr}),
  })
end)

vim.diagnostic.config({
  virtual_text = false,
  signs = true,  -- needs to be true because numhl is defined in sign
  update_in_insert = true,
  severity_sort = true,
})
vim.fn.sign_define('DiagnosticSignError', { texthl = '', text = '', numhl = 'LspDiagnosticsDefaultError' })
vim.fn.sign_define('DiagnosticSignWarn', { texthl = '', text = '', numhl = 'LspDiagnosticsDefaultWarning' })
vim.fn.sign_define('DiagnosticSignInfo', { texthl = '', text = '', numhl = 'LspDiagnosticsDefaultInformation' })
vim.fn.sign_define('DiagnosticSignHint', { texthl = '', text = '', numhl = 'LspDiagnosticsDefaultHint' })

-- plugin to configure lua_ls for neovim (must be called before lspconfig)
require('neodev').setup({})
-- expose gloabal vim lua variable
local lua_opts = lsp_zero.nvim_lua_ls({ settings = { Lua = { completion = { callSnippet = "Replace" } } } })
require('lspconfig').lua_ls.setup(lua_opts)

-- docstring in floating window after ( typed
require('lsp_signature').setup({hint_prefix=""})

-- highlight references of symbol under cursor (a-n and a-p to move between them)
require('illuminate').configure({
  delay = 500,
  min_count_to_highlight = 2,
})

mason.setup({})
mason_lspconfig.setup({
  ensure_installed = {
    'jsonls',
    'pyright',
    'lua_ls',
    'bashls',
  },
  handlers = {
    lsp_zero.default_setup,
  },
})

cmp.setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end,
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip'},
    {name = 'buffer', keyword_length = 3},
  },
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<CR>'] = cmp.mapping.confirm({select = false}),
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      menu = ({
        buffer = '[Buffer]',
        path = '[Path]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        luasnip = '[LuaSnip]',
      }),
    }),
  },
})
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})

lspsaga.setup({
  lightbulb = {
    enable = false,
  },
})
vim.keymap.set('n', '<leader>lo', '<cmd>Lspsaga outline<CR>')
vim.keymap.set('n', '<leader>lp', '<cmd>Lspsaga peek_definition<CR>')
