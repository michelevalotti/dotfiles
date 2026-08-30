local gitsigns = require('gitsigns')
local utils = require('utils')

local function pick_commit_and_run_fn(gs_fn, prompt)
    local fn = vim.fn.expand('%:p')
    local bcommits = utils.exec('git rev-list HEAD --oneline -- ' .. fn)
    if bcommits == nil then
        vim.notify('Not in git directory')
        return
    end
    local bcommits_table = utils.split_str(bcommits, '\n')
    vim.ui.select(
        bcommits_table,
        { prompt = prompt },
        function(choice)
            if choice == nil then
                return
            end
            local commit_hash = utils.split_str(choice, ' ')[1]
            vim.notify(commit_hash)
            gs_fn(commit_hash)
        end
    )
end

gitsigns.setup {
    signs                   = {
        add          = { text = '▐' }, -- ▐ (rh half block) or ▎(lh quarter block, since most fonts don't support rh version)
        change       = { text = '▐' },
        delete       = { text = '▐' },
        topdelete    = { text = '▐' },
        changedelete = { text = '▐' },
        untracked    = { text = '┇' },
    },
    signs_staged            = {
        add          = { text = '▐' },
        change       = { text = '▐' },
        delete       = { text = '▐' },
        topdelete    = { text = '▐' },
        changedelete = { text = '▐' },
        untracked    = { text = '┇' },
    },
    current_line_blame_opts = {
        virt_text_pos = 'overlay',   -- 'eol' | 'overlay' | 'right_align'
    },
    word_diff               = true,  -- Toggle with `:Gitsigns toggle_word_diff`
    signs_staged_enable     = true,
    signcolumn              = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl                   = false, -- Toggle with `:Gitsigns toggle_numhl`
    update_debounce         = 100,
    on_attach               = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.nav_hunk("next") end)
            return '<Ignore>'
        end, { expr = true, desc = "Next git hunk" })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.nav_hunk("prev") end)
            return '<Ignore>'
        end, { expr = true, desc = "Prev git hunk" })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage/Unstage Hunk" })
        map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset Hunk" })
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = "Stage/Unstage Hunk" })
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = "Reset Hunk" })
        map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage Buffer" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset Buffer" })
        map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview Hunk" })
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Blame Line" })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle Current Line Blame Gitsigns" })
        map('n', '<leader>hd', gs.diffthis, { desc = "Diff current buffer against index" })
        map('n', '<leader>hD', function() pick_commit_and_run_fn(gs.diffthis, 'Select commit to diff: ') end,
            { desc = "Diff current buffer against picked commit" })
        map('n', '<leader>hE', function() pick_commit_and_run_fn(gs.show, 'Select commit to load into buffer: ') end,
            { desc = "Load selected commit into buffer" })
        map('n', '<leader>gr', gs.refresh, { silent = true, desc = "Gitsigns refresh" })
        map('n', '<leader>gB', gs.blame, { desc = "Open blame sidebar" })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}
