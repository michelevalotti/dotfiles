local dap_breakpoints = require("dap.breakpoints")
local utils = require("utils")

local get_sorted_table_keys = function(t)
    local sorted_keys = {}
    for k, _ in pairs(t) do
        table.insert(sorted_keys, k)
    end
    table.sort(sorted_keys)
    return sorted_keys
end

local get_breakpoints_tables = function(breakpoints)
    local bufnr_t = {}
    local linenr_t = {}
    local sorted_bufnrs = get_sorted_table_keys(breakpoints)
    for _, bufnr in pairs(sorted_bufnrs) do
        table.sort(breakpoints[bufnr], function(x, y) return x.line < y.line end)
        for _, bp in pairs(breakpoints[bufnr]) do
            table.insert(bufnr_t, bufnr)
            table.insert(linenr_t, bp.line)
        end
    end
    return bufnr_t, linenr_t
end

local find_next = function(bufnr_t, linenr_t, reversed)
    local current_bufnr = vim.api.nvim_get_current_buf()
    local current_linenr = vim.api.nvim_win_get_cursor(0)[1]
    local loop_idx = utils.table_len(bufnr_t)
    local prev_bufnr, prev_linenr = bufnr_t[loop_idx], linenr_t[loop_idx]
    for i, bufnr in pairs(bufnr_t) do
        local linenr = linenr_t[i]
        if (bufnr == current_bufnr and linenr > current_linenr) or (bufnr > current_bufnr) then
            if reversed then
                return prev_bufnr, prev_linenr
            else
                return bufnr, linenr
            end
        end
        if not (bufnr == current_bufnr and linenr == current_linenr) then
            prev_bufnr, prev_linenr = bufnr, linenr
        end
    end
    if reversed then
        return prev_bufnr, prev_linenr
    else
        return bufnr_t[1], linenr_t[1]
    end
end

local move_to_next = function(bufnr_t, linenr_t, reversed)
    local next_bufnr, next_linenr = find_next(bufnr_t, linenr_t, reversed)
    vim.api.nvim_set_current_buf(next_bufnr)
    vim.api.nvim_win_set_cursor(0, { next_linenr, 0 })
end

local move_to_next_breakpoint = function(reversed)
    local bps = dap_breakpoints.get()
    if utils.table_len(bps) == 0 then
        vim.notify("No breakpoints found")
        return
    end
    local bufnr_t, linenr_t = get_breakpoints_tables(bps)
    move_to_next(bufnr_t, linenr_t, reversed)
end

local get_stopped_signs_tables = function()
    local bufnr_t = {}
    local linenr_t = {}
    local bufs_with_signs = vim.fn.sign_getplaced()
    table.sort(bufs_with_signs, function(x, y) return x.bufnr < y.bufnr end)
    for _, buf_signs in ipairs(bufs_with_signs) do
        buf_signs = vim.fn.sign_getplaced(buf_signs.bufnr, { group = "*" })[1]
        for _, sign in pairs(buf_signs.signs) do
            if sign.name ~= "DapStopped" then
                goto continue
            end
            table.insert(bufnr_t, buf_signs.bufnr)
            table.insert(linenr_t, sign.lnum) -- signs are already ordered by line number (and priority)
            ::continue::
        end
    end
    return bufnr_t, linenr_t
end

local move_to_next_stopped = function(reversed)
    local bufnr_t, linenr_t = get_stopped_signs_tables()
    if utils.table_len(bufnr_t) == 0 then
        vim.notify("No DapStopped signs found")
        return
    end
    move_to_next(bufnr_t, linenr_t, reversed)
end

local next_bp = function()
    move_to_next_breakpoint(false)
end

local prev_bp = function()
    move_to_next_breakpoint(true)
end

local next_stopped = function()
    move_to_next_stopped(false)
end

local prev_stopped = function()
    move_to_next_stopped(true)
end

vim.keymap.set('n', ']b', next_bp, { desc = 'Next breakpoint' })
vim.keymap.set('n', '[b', prev_bp, { desc = 'Previous breakpoint' })
vim.keymap.set('n', ']S', next_stopped, { desc = 'Next stopped debug line' })
vim.keymap.set('n', '[S', prev_stopped, { desc = 'Previous stopped debug line' })
