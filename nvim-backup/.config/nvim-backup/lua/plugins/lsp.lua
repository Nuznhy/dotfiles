-- general LSP UI config
vim.diagnostic.config({ jump = { float = true } })

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename)
