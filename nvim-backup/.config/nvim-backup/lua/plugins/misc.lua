require "mini.pick".setup()
vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")


require "oil".setup()
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
