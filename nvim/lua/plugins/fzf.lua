local opts = { noremap = true, silent = true }
local fzf_lua = require("fzf-lua")
local actions = require("fzf-lua.actions")

local winopts_fn = function()
    return {
        "default-prompt",
        height = vim.o.lines > 80 and 60 or 0.8,
        width = vim.o.columns > 200 and 160 or 0.8,
        col = 0.5,
        row = vim.o.lines > 80 and 0.3 or 0.5,
        backdrop = 100,
        preview = {
            layout = "vertical",
            vertical = "up:70%",
            delay = 10, -- prevent lag on fast scrolling
            wrap = true,
        },
    }
end

local no_preview_winopts_fn = function()
    local winopts = winopts_fn()
    winopts["height"] = vim.o.lines > 80 and 20 or 0.3
    winopts["width"] = vim.o.columns > 200 and 160 or 0.8
    winopts["row"] = 0.5
    winopts["preview"] = { -- this keeps the default preview, which is to the right
        hidden = true,
        border = "rounded",
    }
    return winopts
end

fzf_lua.setup({
    winopts = winopts_fn,
    previewers = {
        builtin = {
            toggle_behavior = "extend", -- toggling preview doesn't change size of main window
        },
    },
    keymap = {
        builtin = {
            true, -- inherit other default values
            ["<C-u>"] = "preview-page-up",
            ["<C-d>"] = "preview-page-down",
            ["<C-w>"] = "toggle-preview",
            ["<C-q>"] = "toggle-help", -- C-h is already taken (toggle hidden) and C-m is the same sequence as CR
            ["<C-f>"] = "toggle-fullscreen",
        },
        fzf = {
            -- These lines must exist to let fzf know you want to use preview scrolling
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
        },
    },
    defaults = {
        formatter = "path.filename_first",
        git_icons = true,
    },
    files = {
        no_ignore = true,
    },
    grep = {
        multiline = true,
    },
    git = {
        status = {
            actions = {
                ["ctrl-l"] = { fn = actions.git_unstage, reload = true },
                ["ctrl-h"] = { fn = actions.git_stage, reload = true },
                ["left"] = false,
                ["right"] = false,
            },
        },
    },
    builtin = {
        winopts = no_preview_winopts_fn,
    },
    command_history = {
        winopts = no_preview_winopts_fn,
    },
    actions = {
        files = {
            true,
            ["ctrl-g"] = fzf_lua.actions.toggle_ignore, -- C-i is the same sequence as Tab
            ["ctrl-h"] = fzf_lua.actions.toggle_hidden,
        },
    },
    fzf_colors = {
        ["hl"] = { "fg", "Title" },
        ["fg+"] = { "fg", "FzfLuaFzfMatch" },
        ["bg+"] = { "bg", "TabLine" },
        ["hl+"] = { "fg", "Title" },
        ["border"] = { "fg", "FloatBorder" },
        ["pointer"] = { "fg", "FzfLuaFzfMatch" },
        ["gutter"] = "-1",
    },
    fzf_opts = {
        ["--layout"] = "reverse",
        ["--height"] = "100%",
        ["--cycle"] = true,
        ["--preview-border"] = "rounded",
    },
})

local ui_winopts_fn = function()
    return {
        height = 10,
        width = vim.o.columns > 140 and 100 or 0.8,
        col = 0.5,
        row = 0.5,
        preview = {
            hidden = true,
        }
    }
end


fzf_lua.register_ui_select(
    function(opts, items) -- native function for winopts is not supported here
        return {
            winopts = ui_winopts_fn(),
        }
    end
)

local function get_paths_for_wrapper()
    local git_dir = require("utils").get_git_dir()
    local dirs = {}

    for dir in vim.fs.parents(vim.fn.expand("%:p")) do
        if dir ~= git_dir then
            table.insert(dirs, dir)
        end
    end
    if git_dir ~= "" then
        table.insert(dirs, 1, git_dir)
    end

    return dirs
end

local path_selection_wrapper = function(picker, picker_opts)
    picker_opts = picker_opts or {}
    local wrapped_picker = function()
        fzf_lua.fzf_exec(
            get_paths_for_wrapper(),
            {
                actions = {
                    ["default"] = function(selected, action_opts)
                        local picker_cwd = selected[1]
                        picker({ cwd = picker_cwd })
                    end
                },
                winopts = ui_winopts_fn,
            }
        )
    end
    wrapped_picker()
end

local select_plugin_and_act = function(pack_action)
    local plugin_names = {}
    for _, plugin in ipairs(vim.pack.get()) do
        table.insert(plugin_names, plugin.spec.name)
    end
    fzf_lua.fzf_exec(
        plugin_names,
        {
            actions = {
                ["default"] = function(selected, action_opts)
                    pack_action({ selected[1] })
                end
            },
            winopts = ui_winopts_fn,
        }
    )
end

local select_plugin_and_update = function()
    select_plugin_and_act(vim.pack.update)
end

local select_plugin_and_delete = function()
    select_plugin_and_act(vim.pack.del)
end

local utils = require("utils")
vim.keymap.set('n', '<leader>ff', function() fzf_lua.files({ cwd = "~" }) end,
    utils.tbl_extend(opts, { desc = "Find File" }))
vim.keymap.set('n', '<leader>fg', fzf_lua.grep_project, utils.tbl_extend(opts, { desc = "Find Grep" }))
vim.keymap.set('n', '<leader>fs', fzf_lua.grep_cword,
    utils.tbl_extend(opts, { desc = "Find string under cursor (or in visual selection)" }))
vim.keymap.set('v', '<leader>fs', fzf_lua.grep_visual,
    utils.tbl_extend(opts, { desc = "Find string under cursor (or in visual selection)" }))
vim.keymap.set('n', '<leader>fb', fzf_lua.buffers, utils.tbl_extend(opts, { desc = "Find Buffer" }))
vim.keymap.set('n', '<leader>fh', fzf_lua.helptags, utils.tbl_extend(opts, { desc = "Find Help Tag" }))
vim.keymap.set('n', '<leader>fo', fzf_lua.oldfiles, utils.tbl_extend(opts, { desc = "Find Recent File" }))
vim.keymap.set('n', '<leader>fj', fzf_lua.jumps, utils.tbl_extend(opts, { desc = "Find jump list" }))
vim.keymap.set('n', '<leader>fm', fzf_lua.marks, utils.tbl_extend(opts, { desc = "Find marks" }))
vim.keymap.set('n', '<leader>fH', fzf_lua.command_history, utils.tbl_extend(opts, { desc = "Find command history" }))
vim.keymap.set('n', '<leader>fB', fzf_lua.builtin, utils.tbl_extend(opts, { desc = "Find fzf builtin picker" }))
vim.keymap.set('n', '<leader>fl', fzf_lua.resume, utils.tbl_extend(opts, { desc = "Reopen last fzf picker" }))
vim.keymap.set('n', '<leader>ft', fzf_lua.treesitter, utils.tbl_extend(opts, { desc = "Fzf treesitter" }))

vim.keymap.set('n', '<leader>fF', function() path_selection_wrapper(fzf_lua.files) end,
    utils.tbl_extend(opts, { desc = "Select dir and find file" }))
vim.keymap.set('n', '<leader>fG', function() path_selection_wrapper(fzf_lua.grep_project) end,
    utils.tbl_extend(opts, { desc = "Select dir and find grep" }))
vim.keymap.set('n', '<leader>fS', function() path_selection_wrapper(fzf_lua.grep_cword) end,
    utils.tbl_extend(opts, { desc = "Select dir and find selection" }))
vim.keymap.set('v', '<leader>fS', function() path_selection_wrapper(fzf_lua.grep_visual) end,
    utils.tbl_extend(opts, { desc = "Select dir and find selection" }))

vim.keymap.set('n', '<leader>fp', fzf_lua.dap_breakpoints, utils.tbl_extend(opts, { desc = "Find Debugger Breakpoints" }))

vim.keymap.set('n', '<leader>lr', fzf_lua.lsp_references, utils.tbl_extend(opts, { desc = "Fzf list references" }))
vim.keymap.set('n', 'gd', fzf_lua.lsp_definitions, utils.tbl_extend(opts, { desc = "Go to definition" }))
vim.keymap.set('n', '<leader>lo', fzf_lua.lsp_document_symbols, utils.tbl_extend(opts, { desc = "Fzf buffer symbols" }))
vim.keymap.set('n', '<leader>ld', fzf_lua.diagnostics_document,
    utils.tbl_extend(opts, { desc = "Fzf list buffer diagnostics" }))
vim.keymap.set('n', '<leader>la', fzf_lua.diagnostics_workspace,
    utils.tbl_extend(opts, { desc = "Fzf list all diagnostics" }))

local git_picker_opts = function()
    return {
        cwd = require("utils").get_git_dir(),
        winopts = {
            preview = {
                border = "rounded",
            },
        },
    }
end
vim.keymap.set('n', '<leader>gf', function() fzf_lua.git_files(git_picker_opts()) end,
    utils.tbl_extend(opts, { desc = "Fzf git tracked files" }))
vim.keymap.set('n', '<leader>gb', function() fzf_lua.git_branches(git_picker_opts()) end,
    utils.tbl_extend(opts, { desc = "Fzf git branches" }))
vim.keymap.set('n', '<leader>gs', function() fzf_lua.git_status(git_picker_opts()) end,
    utils.tbl_extend(opts, { desc = "Fzf git status" }))
vim.keymap.set('n', '<leader>gS', function() fzf_lua.git_stash(git_picker_opts()) end,
    utils.tbl_extend(opts, { desc = "Fzf git stash" }))
vim.keymap.set('n', '<leader>gC', function() fzf_lua.git_commits(git_picker_opts()) end,
    utils.tbl_extend(opts, { desc = "Fzf git commits" }))
vim.keymap.set('n', '<leader>gc', function() fzf_lua.git_bcommits(git_picker_opts()) end,
    utils.tbl_extend(opts, { desc = "Fzf git buffer commits" }))

local neoclip = require('neoclip')
neoclip.setup({
    keys = { fzf = { paste = 'ctrl-j' } } -- <c-p> is already previous
})
vim.keymap.set('n', '<leader>fc', require('neoclip.fzf'), utils.tbl_extend(opts, { desc = "Fzf clipboard" }))

vim.keymap.set('n', '<leader>PD', select_plugin_and_delete, utils.tbl_extend(opts, { desc = "Pick plugin to delete" }))
vim.keymap.set('n', '<leader>PU', select_plugin_and_update, utils.tbl_extend(opts, { desc = "Pick plugin to update" }))

local get_sessions = function()
    vim.fn.mkdir(vim.g.sessions_dir, "p")
    local filepaths = {}
    for _, name in ipairs(vim.fn.readdir(vim.g.sessions_dir)) do
        table.insert(filepaths, name)
    end
    return filepaths
end

local source_session = function()
    local session_paths = get_sessions()
    fzf_lua.fzf_exec(
        session_paths,
        {
            actions = {
                ["default"] = function(selected)
                    vim.cmd.source(vim.fs.joinpath(vim.g.sessions_dir, selected[1]))
                end
            },
            winopts = ui_winopts_fn,
        }
    )
end

local delete_session = function()
    local session_paths = get_sessions()
    fzf_lua.fzf_exec(
        session_paths,
        {
            actions = {
                ["default"] = function(selected)
                    os.remove(vim.fs.joinpath(vim.g.sessions_dir, selected[1]))
                end
            },
            winopts = ui_winopts_fn,
        }
    )
end

local write_session = function()
    local session_name = vim.fn.input('session file name (defaults to Session.vim): ')
    if session_name == "" then
        session_name = "Session.vim"
    end
    session_name = vim.fs.joinpath(vim.g.sessions_dir, session_name)
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_name))
end

vim.keymap.set('n', '<leader>ss', source_session, { noremap = true, silent = true, desc = "Select session to load" })
vim.keymap.set('n', '<leader>sm', write_session, { noremap = true, desc = "Make session with name" })
vim.keymap.set('n', '<leader>sd', delete_session, { noremap = true, desc = "select session to delete" })
