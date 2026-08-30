local highlight_overrides = function(C)
    return {
        Visual = { bg = C.surface0 },
        NormalFloat = { bg = C.base },
        FloatBorder = { fg = C.lavender, bg = C.base },
        Whitespace = { fg = C.crust, bg = C.base }, -- for listchars
        Pmenu = { bg = C.base, fg = C.lavender },
        PmenuSel = { bg = C.surface0, fg = C.subtext0 },
        PmenuSbar = { bg = C.base },
        PmenuThumb = { bg = C.lavender },
        StatusLine = { bg = C.base },
        FzfLuaFzfMatch = { fg = C.flamingo },
    }
end

require("catppuccin").setup({
    float = {
        transparent = true,
        solid = false,
    },
    flavour = vim.g.catppuccin_flavour,
    transparent_background = false,
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
    },
    integrations = {
        gitsigns = true,
        treesitter_context = true,
        nvim_surround = false,
        mason = true,
        which_key = true,
        flash = true,
        fzf = true,
        colorful_winsep = {
            enabled = true,
            color = "lavender",
        },
    },
    highlight_overrides = {
        latte = highlight_overrides,
        frappe = highlight_overrides,
        macchiato = highlight_overrides,
        mocha = highlight_overrides,
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
