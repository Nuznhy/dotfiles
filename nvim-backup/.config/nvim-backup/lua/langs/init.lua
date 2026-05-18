local M = {}

M.parsers = {}
M.servers = {}

local languages = {
    "lua",
    "typescript",
    -- "vue",
    -- "python",
}

for _, lang in ipairs(languages) do
    local config = require("langs." .. lang)

    if config.parsers then
        vim.list_extend(M.parsers, config.parsers)
    end

    if config.servers then
        vim.list_extend(M.servers, config.servers)
    end
end

-- Treesitter once
-- require("nvim-treesitter").setup({
--     ensure_installed = M.parsers,
--     highlight = { enable = true },
--     auto_install = true,
-- })

-- Enable LSP once
vim.lsp.enable(M.servers)

return M
