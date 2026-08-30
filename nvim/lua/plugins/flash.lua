local flash_opts = {
    modes = {
        search = { enabled = false },
        char = { enabled = false }
    },
    label = {
        style = "overlay", -- one of "overlay", "eol", "right_align", "inline"
    },
    prompt = {
        enabled = false,
    },
}
local flash = require("flash")
flash.setup(flash_opts)

local utils = require("utils")
local keymap_opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "<leader>j", function() flash.jump() end,
    utils.tbl_extend(keymap_opts, { desc = "Flash jump to" }))
vim.keymap.set("n", "<leader>v", function() flash.treesitter() end,
    utils.tbl_extend(keymap_opts, { desc = "Flash visual select treesitter element" }))
vim.keymap.set("o", "R", function() flash.remote() end, utils.tbl_extend(keymap_opts, { desc = "Flash remote" }))                               -- moves cursor, for mode see :h mapmode-o
vim.keymap.set({ "o", "x" }, "r", function() flash.treesitter_search() end,
    utils.tbl_extend(keymap_opts, { desc = "Flash treesitter search" }))                                                                        -- moves cursor and performs action
