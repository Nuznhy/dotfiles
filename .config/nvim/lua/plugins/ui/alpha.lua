local logo = {
    [[                                     ,]],
    [[              ,-.       _,---._ __  / \]],
    [[             /  )    .-'       `./ /   \]],
    [[            (  (   ,'            `/    /|]],
    [[             \  `-"             \'\   / |]],
    [[              `.              ,  \ \ /  |]],
    [[               /`.          ,'-`----Y   |]],
    [[              (            ;        |   ']],
    [[              |  ,-.    ,-'         |  /]],
    [[              |  | (   |       nvim | /]],
    [[              )  |  \  `.___________|/]],
    [[              `--'   `--']],
}

return {
    "goolord/alpha-nvim",
    priority = 900,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- 1. Center Logo horizontally
        dashboard.section.header.val = logo
        dashboard.section.header.opts.position = "center"

        -- 2. Configure Buttons
        dashboard.section.buttons.val = {
            dashboard.button("e", "   New file", ":ene <bar> startinsert <cr>"),
            dashboard.button("f", "   Find file", ":Telescope find_files<cr>"),
            dashboard.button("r", "   Recent", ":Telescope oldfiles<cr>"),
            dashboard.button("s", "   Settings", "<cmd>Oil ~/.config/nvim<CR>"),
            dashboard.button("q", "   Quit nvim", ":qa<CR>"),
        }

        -- 3. Dynamic Vertical Centering
        -- We calculate padding based on (terminal height - total height of elements) / 2
        local function get_padding()
            local stats = require("lazy").stats()
            local header_height = #logo
            local buttons_height = #dashboard.section.buttons.val * 2 -- each button is 2 lines
            local footer_height = 1
            local total_height = header_height + buttons_height + footer_height + 4 -- +4 for margins
            local padding = math.floor((vim.o.lines - total_height) / 2)
            return padding > 0 and padding or 1
        end

        -- Calculate padding once for both top and bottom
        local vertical_padding = get_padding()

        dashboard.config.layout = {
            { type = "padding", val = vertical_padding }, -- Top padding
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer,
            { type = "padding", val = vertical_padding }, -- Bottom padding to push footer up
        }

        alpha.setup(dashboard.opts)

        -- 4. Hide UI Elements for "Fullscreen" feel
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                vim.opt_local.laststatus = 0
                vim.opt_local.showtabline = 0
                vim.opt_local.foldcolumn = "0"
            end,
        })

        -- Restore UI when leaving Alpha
        -- vim.api.nvim_create_autocmd("BufUnload", {
        --     buffer = 0,
        --     callback = function()
        --         vim.opt.laststatus = 3 -- Global statusline
        --         vim.opt.showtabline = 1
        --     end,
        -- })

        -- Footer stats
        vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
