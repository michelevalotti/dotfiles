local t = require('telescope')
local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local opts = {noremap = true, silent = true}

t.setup({
  pickers = {
    buffers = {
      ignore_current_buffer = true,
      sort_mru = true,
      mappings = {
        n = {
          ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
        },
        i = {
          ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
        }
      },
    },
    builtin = { previewer = false }
  },
  defaults = vim.tbl_extend("force",
    themes.get_dropdown(),
    {
      mappings = {
        n = {
          ["<C-w>"] = action_layout.toggle_preview,
          ["q"] = actions.close,
          ["l"] = actions.results_scrolling_right,
          ["h"] = actions.results_scrolling_left,
        },
        i = {
          ["<C-w>"] = action_layout.toggle_preview,
        },
      },
      path_display = { "smart" },
  }),
  extensions = {
    fzf = {
      fuzzy = false,                   -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- "smart_case" (def) or "ignore_case" or "respect_case"
    },
  }
})

t.load_extension('dap')
t.load_extension('fzf')
t.load_extension('ui-select')

vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, opts)
vim.keymap.set('n', '<leader>fj', builtin.jumplist, opts)
vim.keymap.set('n', '<leader>fB', builtin.builtin, opts)

vim.keymap.set('n', '<leader>dC', t.extensions.dap.commands, opts)
vim.keymap.set('n', '<leader>db', t.extensions.dap.list_breakpoints, opts)
vim.keymap.set('n', '<leader>dr', t.extensions.dap.frames, opts)

vim.keymap.set('n', '<leader>lr', builtin.lsp_references, opts)
vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
vim.keymap.set('n', '<leader>lp', function() builtin.lsp_definitions({jump_type = 'never' }) end, opts)
vim.keymap.set('n', '<leader>lo', builtin.lsp_document_symbols, opts)
vim.keymap.set('n', '<leader>ld', function() builtin.diagnostics{bufnr=0} end, opts)
vim.keymap.set('n', '<leader>la', builtin.diagnostics, opts)

vim.keymap.set('n', '<leader>gF', builtin.git_files, opts)
vim.keymap.set('n', '<leader>gb', builtin.git_branches, opts)
vim.keymap.set('n', '<leader>gs', builtin.git_status, opts)
vim.keymap.set('n', '<leader>gS', builtin.git_stash, opts)
vim.keymap.set('n', '<leader>gC', builtin.git_commits, opts)
vim.keymap.set('n', '<leader>gc', builtin.git_bcommits, opts)
vim.keymap.set('v', '<leader>gc', builtin.git_bcommits_range, opts)

local neoclip = require('neoclip')
neoclip.setup()
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope neoclip<CR>', opts)
