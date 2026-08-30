local blink = require("blink.cmp")
blink.setup({
    fuzzy = { implementation = "rust" },
    sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
            },
            snippets = {
                should_show_items = function(ctx)
                    return ctx.trigger.initial_kind ~= "trigger_character"
                end
            }
        },
    },
    completion = {
        menu = {
            draw = {
                columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "source_name", gap = 1 } },
                treesitter = { "lsp" },
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            treesitter_highlighting = true,
        },
        ghost_text = { enabled = false },
    },
    signature = {
        enabled = true,
        window = {
            show_documentation = true,
        },
    },
    keymap = {
        preset = 'none',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-f>'] = { 'snippet_forward', 'fallback' },
        ['<C-b>'] = { 'snippet_backward', 'fallback' },
    },
    cmdline = {
        completion = {
            ghost_text = { enabled = false },
            menu = { auto_show = false },
            list = {
                selection = {
                    auto_insert = true,
                },
            },
        },
        keymap = {
            preset = "cmdline",
        },
    },
})

vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { link = "PmenuThumb" })
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
