vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { 'vue' },
})

vim.lsp.config('vue_ls', {})

return {
    parsers = { 'vue' },
    servers = { 'vtsls', 'vue_ls' }
}
