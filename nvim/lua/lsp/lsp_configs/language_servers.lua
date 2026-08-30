-- mason executables and lsp config names are different
-- find the mappings in :h lspconfig-all
local language_servers_list = {
    'jsonls',
    'jedi_language_server',
    'lua_ls',
    'bashls',
    'clangd',
    'terraformls',
    'cucumber_language_server',
}

return language_servers_list
