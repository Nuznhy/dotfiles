-- sync theme with noctalia-shell --
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


vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.cmd("wincmd L")
  end,
})

