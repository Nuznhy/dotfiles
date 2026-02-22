vim.lsp.config('tailwindcss', {
    settings = {
        tailwindCSS = {
            files = {
                exclude = {
                    "**/.venv/**",
                    "**/site-packages/**",
                },
            },
            classAttributes = { "class", "className", "classList", "ngClass", "ui", },
        },
    },
})

return {
    servers = {"tailwindcss"},
    parsers = {}
}
