local vuelanguage_server_path = vim.fn.stdpath('data') ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vuelanguage_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
}

vim.lsp.config('vue_ls', {
    filetypes = { 'typescript', 'vue' },
    root_dir = function(bufnr, on_dir)
        local path = vim.api.nvim_buf_get_name(bufnr)

        -- find a vite.config.ts or vite.config.js up the directory tree
        local root = vim.fs.find({ "vite.config.ts", "vite.config.js" }, {
            upward = true,
            path = vim.fn.fnamemodify(path, ":p:h"),
        })[1]

        if root then
            -- call on_dir with the directory containing the file
            on_dir(vim.fs.dirname(root))
        end
    end,
})

vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { 'typescript', 'vue' },
    root_dir = function(bufnr, on_dir)
        local path = vim.api.nvim_buf_get_name(bufnr)

        -- find a vite.config.ts or vite.config.js up the directory tree
        local root = vim.fs.find({ "vite.config.ts", "vite.config.js" }, {
            upward = true,
            path = vim.fn.fnamemodify(path, ":p:h"),
        })[1]

        if root then
            -- call on_dir with the directory containing the file
            on_dir(vim.fs.dirname(root))
        end
    end,
})

return {
    parsers = { 'vue' },
    servers = { 'vtsls', 'vue_ls' }
}
