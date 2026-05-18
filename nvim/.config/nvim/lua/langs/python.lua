vim.lsp.config("basedpyright", {})
vim.lsp.config("ruff", {})
vim.lsp.config("pylsp", {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                pyflakes = { enabled = false },
                flake8 = { enabled = false },
                ruff = { enabled = true },
                pylsp_mypy = {
                    enabled = true,
                    live_mode = true
                },
            }
        }
    }
})

return {
    servers = { 'pylsp', 'basedpyright' },
    parsers = { "python", "rst", "toml" }
}
