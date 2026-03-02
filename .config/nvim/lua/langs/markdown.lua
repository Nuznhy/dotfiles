vim.lsp.config("marksman", {})

return {
    parsers = { "markdown", "markdown_inline" },
    servers = { "marksman" },
}
