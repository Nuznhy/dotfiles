vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    },
    cmd = {"lua-language-server"},
    filetypes = {"lua"}
})

return {
    parsers = { "lua" },
    servers = { "lua_ls" },
}
