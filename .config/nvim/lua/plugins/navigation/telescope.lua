return {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    opts = function()
        return {
            pickers = {
                find_files = {
                    hidden = true
                }
            },
            defaults = {
                mappings = {
                    n = {
                        ['d'] = require("telescope.actions").delete_buffer,
                        ['q'] = require("telescope.actions").close,
                    }
                }
            }
        }
    end,
    keys = function()
        local telescope_builtin = require "telescope.builtin"
        local keymaps = {
            { '<leader>pf', telescope_builtin.find_files,                                                    {} },
            { '<C-p>',      telescope_builtin.git_files,                                                     {} },
            { '<leader>ps', function() telescope_builtin.grep_string({ search = vim.fn.input "Grep >" }) end },
        }
        return keymaps
    end
}
