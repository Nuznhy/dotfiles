return {
    'stevearc/conform.nvim',
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            vue = { "prettierd", "prettier", stop_after_first = true },
            htmldjango = { "djlint" },
            twig = { "djlint" }
        },
        formatters = {
            djlint = {
                -- Pass extra arguments to djlint
                args = function(self, ctx)
                    local indent = vim.bo[ctx.buf].tabstop or 4
                    return { "-", "--reformat", "--indent", indent, "--profile", "django" }
                end,
            },
        },
    },
}
