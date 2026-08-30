local starter = require("mini.starter")

vim.api.nvim_create_autocmd("VimLeavePre", {
    desc = "Save session before leaving if one is laoded",
    callback = function()
        local session_fn = vim.v.this_session
        if session_fn ~= "" and vim.fn.filereadable(session_fn) == 1 then
            print("saving session " .. session_fn)
            vim.cmd("mksession! " .. vim.fn.fnameescape(session_fn))
        end
    end
})

local show_sessions = function()
    local session_fns = vim.fn.readdir(vim.g.sessions_dir)
    local items = {}
    for _, name in ipairs(session_fns) do
        table.insert(items, {
            name = name,
            action = "source" .. vim.fs.joinpath(vim.g.sessions_dir, name),
            section = "Sessions"
        })
    end
    return items
end

local header_art =
[[
 ╭──╮  ╭┬────╮╭─────╮┬   ┬┬╭──┬──╮
 │  │  ││     │     ││   │││  │  │
 │  │  ││     │     ││   │││  │  │
 │  │  │├──┤  │     │╰╮ ╭╯││  │  │
 │  │  ││     │     │ │ │ ││  │  │
 │  │  ││     │     │ │ │ ││  │  │
 ╯  ╰──╯╰────╯╰─────╯ ╰─╯ ┴┴     ┴
]]
starter.setup({
    header = header_art,
    items = {
        show_sessions,
        starter.sections.recent_files(5, false, false),
        starter.sections.builtin_actions(),
    }
})
