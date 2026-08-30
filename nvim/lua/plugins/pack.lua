vim.pack.add({
    'https://github.com/AckslD/nvim-neoclip.lua',
    'https://github.com/arborist-ts/arborist.nvim',
    { src = 'https://github.com/barrettruth/canola.nvim', version = 'canola' },
    'https://github.com/barrettruth/canola-collection',
    { src = "https://github.com/catppuccin/nvim",         name = "catppuccin" },
    'https://github.com/folke/flash.nvim',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/folke/which-key.nvim',
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/igorlfs/nvim-dap-view',
    'https://github.com/kylechui/nvim-surround',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/mfussenegger/nvim-lint',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/nvim-mini/mini.hipatterns',
    'https://github.com/nvim-mini/mini.starter',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
    'https://github.com/nvim-zh/colorful-winsep.nvim',
    'https://github.com/rachartier/tiny-cmdline.nvim',
    'https://github.com/romainl/vim-cool',
    'https://github.com/RRethy/vim-illuminate',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/windwp/nvim-autopairs',
})
vim.cmd("packadd nvim.undotree") -- built in undotree, open with :Undotree
vim.cmd("packadd nvim.difftool") -- built in difftool for directories or files, open with :DiffTool

-- load plugin configs
local utils = require("utils")

local color_status, color_msg = pcall(require, "plugins.colorscheme") -- make sure other modules can access colors
if not color_status then
    vim.notify("Could not load colroscheme configuration: " .. color_msg, vim.log.levels.ERROR)
end

local configs_dir = vim.api.nvim_get_runtime_file("lua/plugins", false)[1]
local required_fnames = utils.list_dir(configs_dir, true) or {}
for _, fname in ipairs(required_fnames) do
    local modname = string.sub(fname, 1, -5)
    if (modname ~= "pack") and (modname ~= "colorscheme") and (string.sub(modname, 1, 1) ~= "_") then
        local status, msg = pcall(require, "plugins." .. modname)
        if not status then
            vim.notify("Could not load " .. modname .. " configuration: " .. msg, vim.log.levels.ERROR)
        end
    end
end

local get_plugins_to_clean = function()
    local plugin_names = {}
    for _, plugin in ipairs(vim.pack.get()) do
        if not plugin.active then
            table.insert(plugin_names, plugin.spec.name)
        end
    end
    return plugin_names
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>Pl', function() vim.pack.update(nil, { offline = true }) end,
    utils.tbl_extend(opts, { desc = "List installed plugins" }))
vim.keymap.set('n', '<leader>Pu', function() vim.pack.update() end,
    utils.tbl_extend(opts, { desc = "Check plugin updates" }))
vim.keymap.set('n', '<leader>Pk', function() vim.pack.update(nil, { target = 'lockfile' }) end,
    utils.tbl_extend(opts, { desc = "Revert plugin version to lockfile specs" }))
vim.keymap.set('n', '<leader>Pc', function() vim.pack.del(get_plugins_to_clean()) end,
    utils.tbl_extend(opts, { desc = "Delete inactive plugins" }))

vim.keymap.set('n', '<leader>ut', ":Undotree<CR>",
    utils.tbl_extend(opts, { desc = "Toggle Undotree" }))
