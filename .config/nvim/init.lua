vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.signcolumn = "yes"
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.colorcolumn = "120"
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- KEYMAPS --

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")


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
-- PACKER --

vim.pack.add({
    { src = "https://github.com/catppuccin/nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/Saghen/blink.cmp" },
    { src = "https://github.com/mbbill/undotree" },
    { src = "https://github.com/rose-pine/neovim" },

})

-- for v,k in pairs(vim.pack.get()) do for j,i in pairs(k) do if type(i) == 'table' then print(i.name) end  end end

require "mason".setup()
require "mini.pick".setup()
require "oil".setup()
require "nvim-treesitter.configs".setup({
    ensure_installed = {
        "typescript",
        "javascript", "css", "python", "html", "vue", "lua", "json", "bash", "cpp", "cmake", "git_config", "gitcommit",
        "http", "json5", "make", "scss", "c", "vim", "vimdoc", "query" },
    highlight = { enable = true },
    sync_install = false,
    auto_install = true
})

-- TELESCOPE --
require "telescope".setup({
    pickers = {
        find_files = {
            hidden = true
        }
    }
})
local telescope_builtin = require "telescope.builtin"
vim.keymap.set('n', '<leader>pf', telescope_builtin.find_files, {})
vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function() telescope_builtin.grep_string({ search = vim.fn.input "Grep >" }) end)

-- LSP --
local lspconfig = require("lspconfig")

lspconfig.somesass_ls.setup({
    filetypes = { "sass", "scss", "less", "css", "html" }
})

lspconfig.ts_ls.setup({
    name = "ts_ls",
    root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json"),
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }
})

local vuelanguage_server_path = vim.fn.stdpath('data') ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vuelanguage_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
}

vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { 'vue' },
})

lspconfig.eslint.setup({ settings = { format = true } })
lspconfig.tailwindcss.setup({
    settings = {
        tailwindCSS = {
            files = {
                exclude = {
                    "**/.venv/**",
                    "**/site-packages/**",
                },
            },
        },
    },
})
vim.lsp.enable({ "lua_ls", "typst", "ts_ls", "vtsls", "vue_ls", "pyright", "bashls", "djlsp", "eslint", "somesass_ls", "html", "clangd", "tinymist"})
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true), }
        }
    }
})

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.diagnostic.config({ jump = { float = true } })
vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename)

require "catppuccin".setup({
    transparent_background = false,
    float = { transparent = false, solid = false },
    custom_highlights = function(colors)
        return { Pmenu = { bg = colors.base }, LineNr = { fg = colors.subtext0 } }
    end
})

-- vim.cmd("colorscheme catppuccin-mocha")
vim.cmd("colorscheme rose-pine")
vim.cmd(":hi statusline guibg=NONE")

require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
    signature = { enabled = true },
    fuzzy = {
        --        implementation = "lua",
        sorts = {
            'exact',
            -- defaults
            'score',
            'sort_text',
        },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
            auto_show = true,
            draw = {
                treesitter = { "lsp" },
                columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } }
            }
        }
    }
})
