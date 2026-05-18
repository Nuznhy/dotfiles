local M = {}

M.parsers = {
    "typescript",
    "javascript", "css", "python", "html", "vue", "lua", "json", "bash", "cpp", "cmake", "git_config", "gitcommit",
    "http", "json5", "make", "scss", "c", "vim", "vimdoc", "query",
}

require "nvim-treesitter".setup({
    ensure_installed = M.parsers,
    auto_install = true,
})

return M
