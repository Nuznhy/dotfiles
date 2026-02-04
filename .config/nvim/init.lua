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

vim.cmd.cd(vim.fn.getcwd())
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
    { src = "https://github.com/milanglacier/minuet-ai.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/Saghen/blink.cmp",                   version = "v1.8.0" },
    { src = "https://github.com/mbbill/undotree" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/vinnymeller/swagger-preview.nvim" },
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/nvimtools/none-ls.nvim" },
    { src = "https://github.com/MunifTanjim/prettier.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/esmuellert/vscode-diff.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/nickjvandyke/opencode.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" }
})

-- for v,k in pairs(vim.pack.get()) do for j,i in pairs(k) do if type(i) == 'table' then print(i.name) end  end end

require "mason".setup()
require "mini.pick".setup()
require "oil".setup()
require "nvim-treesitter.configs".setup({
    modules = {},
    ensure_installed = {
        "typescript",
        "javascript", "css", "python", "html", "vue", "lua", "json", "bash", "cpp", "cmake", "git_config", "gitcommit",
        "http", "json5", "make", "scss", "c", "vim", "vimdoc", "query",
    },
    ignore_install = {},
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
vim.lsp.config('somesass_ls', {
    filetypes = { "sass", "scss", "less", "css", "html" }
})

vim.lsp.config('ts_ls', {
    name = "ts_ls",
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

vim.lsp.config('eslint', { settings = { format = true } })
vim.lsp.config('tailwindcss', {
    settings = {
        tailwindCSS = {
            files = {
                exclude = {
                    "**/.venv/**",
                    "**/site-packages/**",
                },
            },
            classAttributes = { "class", "className", "classList", "ngClass", "ui", },
        },
    },
})
vim.lsp.enable({ "lua_ls", "typst", "ts_ls", "vtsls", "vue_ls", "pyright", "bashls", "djlsp", "eslint", "somesass_ls",
    "html", "clangd", "tinymist", "tailwindcss" })
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

-- local prettier = require("prettier")
--
-- prettier.setup({
--   bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
--   filetypes = {
--     "css",
--     "graphql",
--     "html",
--     "javascript",
--     "javascriptreact",
--     "json",
--     "less",
--     "markdown",
--     "scss",
--     "typescript",
--     "typescriptreact",
--     "yaml",
--   },
-- })
-- local null_ls = require("null-ls")
-- null_ls.setup(
--     {
--         sources = {
--             null_ls.builtins.formatting.prettier,
--         },
--         on_attach = function(client, bufnr)
--             if client.supports_method("textDocument/formatting") then
--                 local aug = vim.api.nvim_create_augroup("LspFormatting", {})
--                 vim.api.nvim_clear_autocmds({ group = aug, buffer = bufnr })
--                 vim.api.nvim_create_autocmd("BufWritePre", {
--                     group = aug,
--                     buffer = bufnr,
--                     callback = function()
--                         vim.lsp.buf.format({ bufnr = bufnr })
--                     end,
--                 })
--             end
--         end,
--     }
-- )


require "catppuccin".setup({
    transparent_background = false,
    float = { transparent = false, solid = false },
    custom_highlights = function(colors)
        return { Pmenu = { bg = colors.base }, LineNr = { fg = colors.subtext0 } }
    end
})

require "gruvbox".setup({
    transparent_mode = true
})

vim.g.rose_pine_variant = "main"
require("rose-pine").setup({
    variant = vim.g.rose_pine_variant,
    dark_variant = "main",
    styles = {
        transparency = true,
    },
})

-- vim.cmd("colorscheme catppuccin-mocha")
-- vm.cmd("colorscheme gruvbox")
vim.cmd("colorscheme rose-pine")
vim.cmd(":hi statusline guibg=NONE")

local is_dark = false

function ToggleRosePine()
    if is_dark then
        vim.g.rose_pine_variant = "dawn"
        is_dark = false
        require("rose-pine").setup({
            variant = vim.g.rose_pine_variant,
            dark_variant = "main",
            styles = {
                transparency = false,
            },
        })
    else
        vim.g.rose_pine_variant = "main"
        is_dark = true
        require("rose-pine").setup({
            variant = vim.g.rose_pine_variant,
            dark_variant = "main",
            styles = {
                transparency = true
            },
        })
    end
    vim.cmd("colorscheme rose-pine")
    vim.cmd(":hi statusline guibg=NONE")
end

-- map it to <leader>tc (you can change this)
vim.api.nvim_set_keymap("n", "<leader>tc", "<cmd>lua ToggleRosePine()<CR>", { noremap = true, silent = true })

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
    -- keymap = {
    --     -- Manually invoke minuet completion.
    --     ['<A-y>'] = require('minuet').make_blink_map(),
    -- },
    sources = {
        -- Enable minuet for autocomplete
        default = { 'lsp', 'path', 'buffer', 'snippets'  },
        -- default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
        -- For manual completion only, remove 'minuet' from default
        -- providers = {
        --     minuet = {
        --         name = 'minuet',
        --         module = 'minuet.blink',
        --         async = true,
        --         -- Should match minuet.config.request_timeout * 1000,
        --         -- since minuet.config.request_timeout is in seconds
        --         timeout_ms = 3000,
        --         score_offset = 50, -- Gives minuet higher priority among suggestions
        --     },
        -- },
    },
    completion = {
        trigger = { prefetch_on_insert = false },
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


-- require("ibl").setup()
require("swagger-preview").setup({ port = 3011, host = "localhost" })

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
                'WinEnter',
                'BufEnter',
                'BufWritePost',
                'SessionLoadPost',
                'FileChangedShellPost',
                'VimResized',
                'Filetype',
                'CursorMoved',
                'CursorMovedI',
                'ModeChanged',
            },
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = {},
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

local snacks = require("snacks")
snacks.setup({
    animate = { enabled = true },
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = false },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    terminal = { enabled = true }
})

vim.keymap.set({ "n", "x" }, "<leader>t", function() snacks.terminal() end, { desc = "Toggle terminal" })

-- Required for `opts.events.reload`.
vim.o.autoread = true

local opencode = require("opencode")

-- Primary Actions
vim.keymap.set({ "n", "x" }, "<C-a>", function() opencode.ask("@this: ", { submit = true }) end,
    { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<C-x>", function() opencode.select() end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<C-s>", function() opencode.toggle() end, { desc = "Toggle opencode" })

-- Operator mappings
vim.keymap.set({ "n", "x" }, "go", function() return opencode.operator("@this ") end,
    { desc = "Add range to opencode", expr = true })
vim.keymap.set("n", "goo", function() return opencode.operator("@this ") .. "_" end,
    { desc = "Add line to opencode", expr = true })

-- Scrolling
vim.keymap.set("n", "<S-C-u>", function() opencode.command("session.half.page.up") end, { desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-C-d>", function() opencode.command("session.half.page.down") end,
    { desc = "Scroll opencode down" })

-- Remapping Increment/Decrement (Opinionated remaps from the original config)
-- These override the default <C-a> and <C-x> behavior to + and -
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })


-- require('minuet').setup {
--     provider = 'openai_fim_compatible',
--     n_completions = 1, -- recommend for local model for resource saving
--     -- I recommend beginning with a small context window size and incrementally
--     -- expanding it, depending on your local computing power. A context window
--     -- of 512, serves as an good starting point to estimate your computing
--     -- power. Once you have a reliable estimate of your local computing power,
--     -- you should adjust the context window to a larger value.
--     context_window = 512,
--     provider_options = {
--         openai_fim_compatible = {
--             -- For Windows users, TERM may not be present in environment variables.
--             -- Consider using APPDATA instead.
--             api_key = 'TERM',
--             name = 'Ollama',
--             end_point = 'http://localhost:11434/v1/completions',
--             model = 'qwen2.5-coder:7b',
--             optional = {
--                 max_tokens = 56,
--                 top_p = 0.9,
--             },
--         },
--     },
-- }
