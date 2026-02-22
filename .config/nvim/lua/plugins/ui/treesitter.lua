return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,        -- load immediately
        build = ":TSUpdate", -- update installed parsers after install
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        config = function()
            local langs = require("langs")
            require("nvim-treesitter").install(langs.parsers)

            -- 2) Enable highlighting
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf, args.match)
                end,
            })

            -- 3) Optional: indentation
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            require("nvim-ts-autotag").setup({})
        end,
    },
}
