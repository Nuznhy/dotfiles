vim.lsp.config('ts_ls', {
    name = "ts_ls",
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_dir = function(bufnr, on_dir)
        local name = vim.api.nvim_buf_get_name(bufnr)
        -- find vite config up the tree
        local is_vite = vim.fs.find({ "vite.config.ts", "vite.config.js" }, {
            upward = true,
            path = vim.fs.dirname(name),
        })[1]

        -- if Vite config exists, do NOT call on_dir → ts_ls won’t start
        if is_vite then
            return
        end

        -- otherwise, use package.json or tsconfig.json as root
        local root = vim.fs.find({ "package.json", "tsconfig.json" }, {
            upward = true,
            path = vim.fs.dirname(name),
        })[1]

        if root then
            on_dir(vim.fs.dirname(root))
        end
    end,
})

return {
    parsers = { "typescript", "javascript" },
    servers = { "ts_ls" },
}
