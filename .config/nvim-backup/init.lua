require("core.options")
require("core.keymaps")
-- equire("core.autocmd")


vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "master" },
})
vim.cmd("packloadall")
require("plugins") -- installs plugins
require("plugins.mason")
require("plugins.treesitter")
require("plugins.lsp")
-- require("plugins.telescope")
-- require("plugins.completion")
require("plugins.ui")
require("plugins.theme")
require("plugins.misc")

require("nvim-treesitter.configs").setup({
    modules = {},
    ensure_installed = {
        "typescript",
        "javascript", "css", "python", "html", "vue", "lua", "json", "bash", "cpp", "cmake", "git_config", "gitcommit",
        "http", "json5", "make", "scss", "c", "vim", "vimdoc", "query",
    },
    ignore_install = {},
    highlight = { enable = true },
    sync_install = false,
    auto_install = true
})


require("langs")
