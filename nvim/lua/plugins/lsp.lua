local utils = require("utils")
local mason_opts = {
    ui = {
        backdrop = 100,
    }
}
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function() require("mason").setup(mason_opts) end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "mason",
    callback = function() vim.opt_local.cursorline = false end, -- global cursorline setting is overridden by Mason
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function() require('lazydev').setup(require("lsp.lsp_configs.lazydev")) end,
})

local conform_fts = {}
local configs_by_ft = {}
local configs_dir = vim.api.nvim_get_runtime_file("lua/lsp/conform_configs", false)[1]
for _, ft in ipairs(utils.list_dir(configs_dir, true) or {}) do
    ft = string.sub(ft, 1, -5)
    table.insert(conform_fts, ft)
    configs_by_ft[ft] = require('lsp.conform_configs.' .. ft)
end
vim.api.nvim_create_autocmd("FileType", {
    pattern = conform_fts,
    callback = function()
        require("conform").setup({
            formatters_by_ft = configs_by_ft,
            default_format_opts = {
                lsp_format = "fallback",
            },
        })
    end,
})

local lint_fts = {}
local lint_configs_by_ft = {}
local lint_configs_dir = vim.api.nvim_get_runtime_file("lua/lsp/lint_configs", false)[1]
for _, ft in ipairs(utils.list_dir(lint_configs_dir, true) or {}) do
    ft = string.sub(ft, 1, -5)
    table.insert(lint_fts, ft)
    lint_configs_by_ft[ft] = require('lsp.lint_configs.' .. ft)
end
vim.api.nvim_create_autocmd("FileType", {
    pattern = lint_fts,
    callback = function()
        local lint = require("lint")
        lint.linters_by_ft = lint_configs_by_ft
        local lint_augroup = vim.api.nvim_create_augroup("nvim_lint_au", { clear = true })
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
})

local remove_path_from_file_item = function(item)
    if item.kind == 17 or item.kind == 19 then -- File or Folder
        return {
            menu = "",                         -- holds the full path (which is also shown in the popup)
            info = "",                         -- setting this to "" adds a border to the popup window (not sure why)
        }
    end
    return { abbr = item.label:gsub("%b()", "") }
end

local signarure_help_fn = function(event, client)
    if vim.api.nvim_get_mode().mode ~= 'i' then return end
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:request("textDocument/signatureHelp", params, function(err, result)
        if err or not (result and result.signatures and result.signatures[1]) then
            return
        end
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local text_before = line:sub(1, col)

        if text_before:match("%s*%(.-[^)]*$") or text_before:match(",%s*$") then
            vim.lsp.buf.signature_help({
                focusable = false,
                anchor_bias = "above",
            })
        end
    end, event.buf)
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, utils.tbl_extend(opts, { desc = "Show docs" }))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, utils.tbl_extend(opts, { desc = "Go to declaration" }))
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, utils.tbl_extend(opts, { desc = "Code Actions" }))
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, utils.tbl_extend(opts, { desc = "Open diagnostics float" }))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, utils.tbl_extend(opts, { desc = "Go to implementation" }))
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, utils.tbl_extend(opts, { desc = "Go to type definition" }))
        vim.keymap.set('n', 'gR', vim.lsp.buf.references, utils.tbl_extend(opts, { desc = "List references" }))
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, utils.tbl_extend(opts, { desc = "Signature Help" }))
        vim.keymap.set('n', 'gn', vim.lsp.buf.rename, utils.tbl_extend(opts, { desc = "Lsp rename" }))
        vim.keymap.set({ 'n', 'v' }, 'gF', require("conform").format,
            utils.tbl_extend(opts, { desc = "lsp format buffer (or visual selection)" }))

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            local chars = { string.char(46) }                          -- 46 is dot
            for i = 48, 57 do table.insert(chars, string.char(i)) end  -- numbers
            for i = 65, 90 do table.insert(chars, string.char(i)) end  -- uppercase letters
            for i = 97, 122 do table.insert(chars, string.char(i)) end -- lowercase letters
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, event.buf,
                {
                    autotrigger = true,
                    convert = function(item) return remove_path_from_file_item(item) end,
                }
            )
        end
        if client and client:supports_method("textDocument/signatureHelp") then
            vim.api.nvim_create_autocmd({ "TextChangedI", "CursorMovedI" }, {
                buffer = event.buf,
                callback = function() signarure_help_fn(event, client) end,
            })
        end
    end
})
vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'LspDiagnosticsDefaultError',
            [vim.diagnostic.severity.WARN] = 'LspDiagnosticsDefaultWarning',
            [vim.diagnostic.severity.INFO] = 'LspDiagnosticsDefaultInformation',
            [vim.diagnostic.severity.HINT] = 'LspDiagnosticsDefaultHint',
        },
    }
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
for _, server_name in ipairs(require("lsp.lsp_configs.language_servers")) do
    local success, additional_settings = pcall(require, "lsp.lsp_configs." .. server_name)
    if not success then additional_settings = {} end
    vim.lsp.config(server_name, {
        capabilities = capabilities,
        settings = additional_settings,
    })
    vim.lsp.enable(server_name)
end

vim.opt.completeopt = { "menu", "menuone", "fuzzy", "popup", "noinsert" }
vim.opt.autocompletedelay = 100
vim.opt.pumheight = 10
vim.opt.shortmess:append("c")

vim.keymap.set('i', '<Tab>', function()
    local def_cmd = vim.bo.ft == "dap-repl" and '<C-x><C-o>' or '<Tab>'
    return vim.fn.pumvisible() == 1 and '<C-n>' or def_cmd
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end, { expr = true })
vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 1 then
        vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
    end
    return require('nvim-autopairs').autopairs_cr() -- needs replace_keycodes = false
end, { expr = true, replace_keycodes = false, noremap = true })


-- TODO: remove this once properly implemented upstream (probably through completepopup)
-- code from https://github.com/neovim/neovim/issues/38248
local function set_popup_border(winid)
    if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
        pcall(vim.api.nvim_win_set_config, winid, { border = "rounded" })
    end
end
if vim.api.nvim__complete_set then
    local orig = vim.api.nvim__complete_set
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim__complete_set = function(index, opts)
        local windata = orig(index, opts)
        set_popup_border(windata and windata.winid)
        return windata
    end
end
