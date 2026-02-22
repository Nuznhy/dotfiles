-- vim.cmd.cd(vim.fn.getcwd())
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

-- move text from line below to current line --
vim.keymap.set("n", "J", "mzJ`z")

-- keep view centered when jumping --
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- duplicate what is not selected in visual block to next line --
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system buffer --
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

-- file view hop / split --
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>S', ':vert sf #<CR>')
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- lsp keymap --
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.diagnostic.config({ jump = { float = true } })
vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename)
