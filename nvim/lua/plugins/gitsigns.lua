local gitsigns = require('gitsigns')
gitsigns.setup {
  signs = {
    add          = { text = '▐' },  -- ▐ (rh half block) or ▎(lh quarter block, since most fonts don't support rh version)
    change       = { text = '▐' },
    delete       = { text = '▐' },
    topdelete    = { text = '▐' },
    changedelete = { text = '▐' },
    untracked    = { text = '┆' },
  },
  current_line_blame_opts = {
    virt_text_pos = 'overlay',  -- 'eol' | 'overlay' | 'right_align'
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  update_debounce = 100,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)
    map('n', '<leader>gr', ':Gitsigns refresh<CR>', {silent=true})

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}


local function get_all_commits_of_this_file()
  local scripts = vim.api.nvim_exec2("!git log --pretty=oneline --abbrev-commit --follow \"%\"", {output=true}).output
  local res = vim.split(scripts, "\n")
  local output = {}
  for index = 3, #res - 1 do
    local item = res[index]
    local hash_id = string.sub(item, 1, 7)
    local message = string.sub(item, 8)
    output[index - 2] = { hash_id = hash_id, message = message }
  end
  return output
end

local function isFugitiveFile()
  local filepath = vim.api.nvim_exec2("echo expand('%:p')", {output=true}).output
  return filepath:find("fugitive", 1, true) == 1
end

local function diffWith()
  -- check if it is a fugitive file
  if isFugitiveFile() then
    vim.ui.input({ prompt = "Please input commit hash id to compare with current version: " }, function(input)
      if input then
        vim.cmd("Gvdiffsplit! " .. input)
      end
    end)
  else
    local commits = get_all_commits_of_this_file();

    vim.ui.select(commits, {
      prompt = "Select commit to compare with current file",
      format_item = function(item)
        return item.hash_id .. " > " .. item.message
      end,
    }, function(choice)
      if choice and choice.hash_id then
        gitsigns.diffthis(choice.hash_id)
      end
    end)
  end
end

vim.keymap.set('n', '<leader>gd', diffWith, { noremap = true, silent = true, desc = "Diff With"})
vim.keymap.set('n', '<leader>gf', ":0Gclog<CR>", { noremap = true, silent = true, desc = "Show Git Quickfix Log"})
