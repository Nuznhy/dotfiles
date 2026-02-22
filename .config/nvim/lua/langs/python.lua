vim.lsp.config("pyright", {})
vim.lsp.config("black", {})

return {
    servers = { 'pyright' },
    parsers = { "python", "rst", "toml" }
}
