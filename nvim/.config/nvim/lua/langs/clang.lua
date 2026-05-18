vim.lsp.config("clangd", {})

return {
    servers = { "clangd" },
    parsers = { "c" }
}
