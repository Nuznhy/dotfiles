return { 
    'nvim-mini/mini.pick',
    version = '*',
    keys = {
        {'<leader>f', ":Pick files<CR>"},
        {'<C-h>', ":Pick help<CR>"}
    },
    config = function()
        require("mini.pick").setup()
    end,
}
