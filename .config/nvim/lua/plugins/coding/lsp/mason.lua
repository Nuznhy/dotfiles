local langs = require("langs")
return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    mason_lspconfig = {
        ensure_installed = {},
        automatic_installation = true,
    },
    opts = {
        mason = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    config = function(_, opts)
        require("mason").setup(opts.mason)
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            ensure_installed = langs.servers,
        })
    end,
}
