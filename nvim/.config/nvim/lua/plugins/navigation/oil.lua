return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        default_file_explorer = true,
        view_options = {
            -- Show files and directories that start with "."
            show_hidden = true
        },
        columns = {
            "icon",
            -- "permissions",
            --"size",
            --"mtime",
        },
        -- git = {
        --     -- Return true to automatically git add/mv/rm files
        --     add = function(path)
        --         return false
        --     end,
        --     mv = function(src_path, dest_path)
        --         return false
        --     end,
        --     rm = function(path)
        --         return false
        --     end,
        -- },
    },
    -- Optional dependencies
    dependencies = { { "nvim-tree/nvim-web-devicons" } }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
        { '<leader>e', ":Oil<CR>" }
    }
}
