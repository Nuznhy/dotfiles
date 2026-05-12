vim.lsp.config('tailwindcss', {
    filetypes = {
        "html",
        "css",
        "scss",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "svelte",
    },
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
