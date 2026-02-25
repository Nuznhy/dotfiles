-- local schemastore = require("schemastore")
vim.lsp.config("spectral", {})

return {
    servers = { "spectral" },
    parsers = { "yaml" }
}
