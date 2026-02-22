vim.lsp.config('ts_ls', {
    name = "ts_ls",
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }
})

return {
    parsers = { "typescript", "javascript" },
    servers = { "ts_ls" },
}
