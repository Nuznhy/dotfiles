vim.lsp.config('eslint', { settings = { format = true } })

return {
    servers = { "eslint" },
    parsers = {}
}
