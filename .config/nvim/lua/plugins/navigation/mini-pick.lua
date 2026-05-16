return {
    'nvim-mini/mini.pick',
    disabled = true,
    version = '*',
    keys = {
        -- { '<leader>f', ":Pick files<CR>" },
        -- { '<C-h>',     ":Pick help<CR>" }
    },
    config = function()
        require("mini.pick").setup()
    end,
}
