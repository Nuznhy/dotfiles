return {
    'brenoprata10/nvim-highlight-colors',
    opts = {
        enable_tailwind = true,
        render = 'background',
    },
    setup = function(_, opts)
        vim.opt.termguicolors = true
        require('nvim-highlight-colors').setup(opts)
    end
}
