require('nvim-treesitter.configs').setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "bash", "markdown", "markdown_inline" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "python" }
  }
})
