vim.lsp.config('vtsls', {
    filetypes = { 'vue' },
})

vim.lsp.config('vue_ls', {})

return {
    parsers = { 'vue' },
    servers = { 'vtsls', 'vue_ls' }
}
