-- sync theme with noctalia-shell --
if vim.fn.executable("qs") == 1 then
    local function get_noctalia_dark_mode()
        local result = vim.system(
            { "qs", "-c", "noctalia-shell", "ipc", "call", "state", "all" },
            { text = true }
        ):wait()

        if result.code ~= 0 then
            return nil
        end

        local ok, decoded = pcall(vim.json.decode, result.stdout)
        if not ok then
            return nil
        end

        return decoded.settings.colorSchemes.darkMode
    end

    local function apply_rose_pine_from_noctalia()
        local is_dark = get_noctalia_dark_mode()

        if is_dark == nil then
            return
        end

        local variant = is_dark and "main" or "dawn"

        require("rose-pine").setup({
            variant = variant,
            dark_variant = "main",
            styles = {
                transparency = is_dark, -- example behavior
            },
        })

        vim.cmd("colorscheme rose-pine")
        vim.cmd("hi statusline guibg=NONE")
    end
    vim.g.rose_pine_variant = "main"
    require("rose-pine").setup({
        variant = vim.g.rose_pine_variant,
        dark_variant = "main",
        styles = {
            transparency = true,
        },
    })

    apply_rose_pine_from_noctalia()
    local signal = vim.uv.new_signal()

    signal:start("sigusr1", vim.schedule_wrap(function()
        apply_rose_pine_from_noctalia()
    end))
    --
else
    require("rose-pine").setup({ variant = "main", dark_variant = "main" })
    vim.cmd("colorscheme rose-pine")
end

-- move help windows to Vertical split --
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.cmd("wincmd L")
    end,
})


-- autoformat on save --
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
