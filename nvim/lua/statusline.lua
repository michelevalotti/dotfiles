local set_hl_groups = function()
    local palette = require("catppuccin.palettes").get_palette(vim.g.catppuccin_flavour)
    for group, opts in pairs({
        ModeNormal = { bg = palette.lavender, fg = palette.base },
        ModePending = { bg = palette.mauve, fg = palette.base },
        ModeVisual = { bg = palette.flamingo, fg = palette.base },
        ModeInsert = { bg = palette.sapphire, fg = palette.base },
        ModeCommand = { bg = palette.teal, fg = palette.base },
        ModeReplace = { bg = palette.maroon, fg = palette.base },
        Base = { bg = palette.crust, fg = palette.subtext0 },
        BaseLavender = { bg = palette.crust, fg = palette.lavender },
        BasePeach = { bg = palette.crust, fg = palette.peach },
        GitAdd = { bg = palette.crust, fg = palette.green },
        GitChange = { bg = palette.crust, fg = palette.yellow },
        GitDelete = { bg = palette.crust, fg = palette.maroon },
        DiagnosticSignHint = { bg = palette.crust, fg = vim.api.nvim_get_hl(0, { name = "DiagnosticSignHint" })["fg"] },
        DiagnosticSignInfo = { bg = palette.crust, fg = vim.api.nvim_get_hl(0, { name = "DiagnosticSignInfo" })["fg"] },
        DiagnosticSignWarn = { bg = palette.crust, fg = vim.api.nvim_get_hl(0, { name = "DiagnosticSignWarn" })["fg"] },
        DiagnosticSignError = { bg = palette.crust, fg = vim.api.nvim_get_hl(0, { name = "DiagnosticSignError" })["fg"] },
    }) do
        group = "StatusLine" .. group
        vim.api.nvim_set_hl(0, group, opts)
        opts.fg, opts.bg = opts.bg, palette.base
        vim.api.nvim_set_hl(0, group .. "Separator", opts)
    end
    for group, opts in pairs({
        BasePeach = { bg = palette.mantle, fg = palette.peach },
        BaseSurface1 = { bg = palette.mantle, fg = palette.surface1 },
    }) do
        group = "WinBar" .. group
        vim.api.nvim_set_hl(0, group, opts)
        opts.fg, opts.bg = opts.bg, palette.base
        vim.api.nvim_set_hl(0, group .. "Separator", opts)
    end
end

set_hl_groups()

local mode_settings = {
    ["n"] = { name = "NORMAL", hl = "Normal" },
    ["no"] = { name = "OP-PENDING", hl = "Pending" },
    ["nov"] = { name = "OP-PENDING", hl = "Pending" },
    ["noV"] = { name = "OP-PENDING", hl = "Pending" },
    ["no\22"] = { name = "OP-PENDING", hl = "Pending" },
    ["niI"] = { name = "NORMAL", hl = "Normal" },
    ["niR"] = { name = "NORMAL", hl = "Normal" },
    ["niV"] = { name = "NORMAL", hl = "Normal" },
    ["nt"] = { name = "NORMAL", hl = "Normal" },
    ["ntT"] = { name = "NORMAL", hl = "Normal" },
    ["v"] = { name = "VISUAL", hl = "Visual" },
    ["vs"] = { name = "VISUAL", hl = "Visual" },
    ["V"] = { name = "V-LINE", hl = "Visual" },
    ["Vs"] = { name = "V-LINE", hl = "Visual" },
    ["\22"] = { name = "V-BLOCK", hl = "Visual" },
    ["\22s"] = { name = "V-BLOCK", hl = "Visual" },
    ["s"] = { name = "SELECT", hl = "Insert" },
    ["S"] = { name = "S-LINE", hl = "Normal" },
    ["\19"] = { name = "S-BLOCK", hl = "Normal" },
    ["i"] = { name = "INSERT", hl = "Insert" },
    ["ic"] = { name = "INSERT", hl = "Insert" },
    ["ix"] = { name = "INSERT", hl = "Insert" },
    ["R"] = { name = "REPLACE", hl = "Replace" },
    ["Rc"] = { name = "REPLACE", hl = "Replace" },
    ["Rx"] = { name = "REPLACE", hl = "Replace" },
    ["Rv"] = { name = "V-REPLACE", hl = "Replace" },
    ["Rvc"] = { name = "V-REPLACE", hl = "Replace" },
    ["Rvx"] = { name = "V-REPLACE", hl = "Replace" },
    ["c"] = { name = "COMMAND", hl = "Command" },
    ["cv"] = { name = "EX", hl = "Command" },
    ["ce"] = { name = "EX", hl = "Command" },
    ["r"] = { name = "REPLACE", hl = "Normal" },
    ["rm"] = { name = "MORE", hl = "Normal" },
    ["r?"] = { name = "CONFIRM", hl = "Normal" },
    ["!"] = { name = "SHELL", hl = "Normal" },
    ["t"] = { name = "TERMINAL", hl = "Command" },
}

local wrap_in_bubble = function(component_txt, hl_name, space_posn, apply_hl_to_body)
    if component_txt == "" then
        return ""
    end
    apply_hl_to_body = apply_hl_to_body or true
    if apply_hl_to_body then
        component_txt = "%#" .. hl_name .. "#" .. component_txt
    end
    local ret = table.concat({
        "%#" .. hl_name .. "Separator" .. "#",
        component_txt,
        "%#" .. hl_name .. "Separator" .. "#",
    })
    if vim.tbl_contains({ "l", "L", "left", "Left", "LEFT" }, space_posn) then
        return " " .. ret
    end
    if vim.tbl_contains({ "r", "R", "right", "Right", "RIGHT" }, space_posn) then
        return ret .. " "
    end
end

local get_mode = function()
    local mode
    if _G.debug_mode_active then
        mode = { name = "DEBUG", hl = "Command" }
    else
        mode = mode_settings[vim.fn.mode()] or {}
    end
    return wrap_in_bubble(mode.name, "StatuslineMode" .. mode.hl, "r")
end

local get_git_info = function()
    local gitsigns_status = vim.b.gitsigns_status_dict
    local gitsigns = ""

    if gitsigns_status then
        local branch = gitsigns_status.head
        local added = gitsigns_status.added
        local changed = gitsigns_status.changed
        local removed = gitsigns_status.removed
        if branch ~= nil and branch ~= "" then
            gitsigns = "%#StatusLineBaseLavender#" .. gitsigns .. " " .. branch
        end
        local gitsigns_status_tbl = {}
        if added ~= nil and added > 0 then
            table.insert(gitsigns_status_tbl, "%#StatusLineGitAdd#+" .. added)
        end
        if changed ~= nil and changed > 0 then
            table.insert(gitsigns_status_tbl, "%#StatusLineGitChange#~" .. changed)
        end
        if removed ~= nil and removed > 0 then
            table.insert(gitsigns_status_tbl, "%#StatusLineGitDelete#-" .. removed)
        end
        local gitsigns_status_str = table.concat(gitsigns_status_tbl, " ")
        if gitsigns_status_str ~= "" then
            gitsigns = gitsigns .. " ❘ " .. gitsigns_status_str
        end
    end
    return wrap_in_bubble(gitsigns, "StatusLineBaseLavender", "r", false)
end

local get_diagnostics_count = function(severity)
    return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] })
end

local get_diagnostics = function()
    local hl_to_dignostic = {
        ["StatusLineDiagnosticSignHint"] = { "󰌶 ", get_diagnostics_count("HINT") },
        ["StatusLineDiagnosticSignInfo"] = { " ", get_diagnostics_count("INFO") },
        ["StatusLineDiagnosticSignWarn"] = { " ", get_diagnostics_count("WARN") },
        ["StatusLineDiagnosticSignError"] = { " ", get_diagnostics_count("ERROR") },
    }
    local diagnostics = {}
    for hl, diagnostic in pairs(hl_to_dignostic) do
        if diagnostic[2] > 0 then
            table.insert(diagnostics, "%#" .. hl .. "#" .. diagnostic[1] .. tostring(diagnostic[2]))
        end
    end
    local diagnostics_str = table.concat(diagnostics, " ")
    return wrap_in_bubble(diagnostics_str, "StatusLineBase", "r", false)
end

local function get_recording()
    local recording_register = vim.fn.reg_recording()
    local recording_str = ""
    if recording_register ~= "" then
        recording_str = "󰑊 REC @ " .. recording_register
    end
    return wrap_in_bubble(recording_str, "StatusLineBasePeach", "l")
end

local get_search_count = function()
    if vim.v.hlsearch == 0 then -- not active when cursor not on search match
        return ""
    end
    local result = vim.fn.searchcount({ maxcount = 0, timeout = 100 })
    local search_str = ""
    if result.total > 0 then
        search_str = string.format(": %d/%d", result.current, result.total)
    end
    return wrap_in_bubble(search_str, "StatusLineBasePeach", "l")
end

local function get_ft_icon()
    local devicons = require('nvim-web-devicons')
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')

    local icon, _ = devicons.get_icon(filename, extension, { default = true })
    return icon
end

local get_file_descriptors = function()
    local ff_symbols = {
        unix = '', -- LF
        dos  = '', -- CRLF
        mac  = '', -- CR
    }
    local descriptors_table = {}
    local enc = vim.bo.fenc
    local ff = vim.bo.fileformat
    local ft = vim.bo.filetype
    if enc ~= "" then
        table.insert(descriptors_table, enc)
    end
    if ff ~= "" then
        table.insert(descriptors_table, ff_symbols[ff])
    end
    if ft ~= "" then
        ft = get_ft_icon() .. " " .. ft
        table.insert(descriptors_table, ft)
    end
    return wrap_in_bubble(table.concat(descriptors_table, " ❘ "), "StatusLineBase", "l")
end

local get_cursor_posn = function()
    local total_lines = vim.api.nvim_buf_line_count(0)
    local cursor_posn = vim.api.nvim_win_get_cursor(0)
    local percent_posn
    if cursor_posn[1] == 1 then
        percent_posn = "Top"
    elseif cursor_posn[1] == total_lines then
        percent_posn = "Bot"
    else
        percent_posn = math.floor(cursor_posn[1] / total_lines * 100)
        percent_posn = string.format("%" .. 2 .. "d", percent_posn) .. "%%"
    end
    percent_posn = wrap_in_bubble(percent_posn, "StatusLineBaseLavender", "l")

    local total_lines_str_len = string.len(tostring(total_lines))
    local longest_col = vim.fn.max(vim.fn.map(vim.fn.getline(1, '$'), 'strdisplaywidth(v:val)'))
    local longest_col_str_len = string.len(longest_col)
    local cur_line = string.format("%" .. total_lines_str_len .. "d", cursor_posn[1])
    local cur_col = string.format("%-" .. longest_col_str_len .. "d", cursor_posn[2] + 1)
    local current_posn = wrap_in_bubble(cur_line .. ":" .. cur_col, "StatusLineModeNormal", "l")

    return percent_posn .. current_posn
end

local excluded_fts = { 'ministarter', 'dap-repl', 'dap-view' }
local M = {}

function M.render_statusline()
    local active_win = vim.fn.win_getid()
    local status_win = tonumber(vim.g.actual_curwin)

    if vim.tbl_contains(excluded_fts, vim.bo.filetype) then
        return "%#StatusLineModeNormalSeparator# "
    end

    if status_win ~= active_win then
        return wrap_in_bubble("%f%m", "StatusLineBase", "r")
    end

    return table.concat({
        get_mode(),
        get_git_info(),
        get_diagnostics(),
        wrap_in_bubble("%F%m", "StatusLineBase", "r"),
        "%=", -- separator for left and right elements
        get_recording(),
        get_search_count(),
        get_file_descriptors(),
        get_cursor_posn(),
    })
end

function M.render_winbar()
    if vim.tbl_contains(excluded_fts, vim.bo.filetype) then
        return "%#StatusLineModeNormalSeparator# "
    end
    local is_mod = vim.bo.modified and '%#WinBarBasePeach# ' or ''
    local content = '%#WinBarBaseSurface1#' .. "%f"
    return wrap_in_bubble(is_mod .. content, "WinBarBaseSurface1", "r", false)
end

return M
