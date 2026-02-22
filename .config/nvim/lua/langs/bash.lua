vim.lsp.config('bashls', { filetypes = {"sh"} })

return {
    parsers = { 'bash' },
    servers = { 'bashls' }
}
