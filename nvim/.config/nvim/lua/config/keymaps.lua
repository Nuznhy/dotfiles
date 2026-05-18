-- vim.cmd.cd(vim.fn.getcwd())
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

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

-- lsp keymap --
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.diagnostic.config({ jump = { float = true } })

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)

vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>")

local function toggle_checkbox()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, row-1, row, false)[1] or ""

  -- match "- [ ]", "- [x]" etc.
  local prefix, state, suffix = line:match("^(.-%[)(.)(%].*)$")
  if prefix then
    -- toggle between space and x
    local new_state = (state == "x") and " " or "x"
    line = prefix .. new_state .. suffix
  else
    -- no checkbox found — insert at cursor start
    line = "- [ ] " .. line
  end

  vim.api.nvim_buf_set_lines(0, row-1, row, false, { line })
end

vim.keymap.set(
  "n",
  "<leader>tt",
  toggle_checkbox,
  { desc = "Toggle Markdown Checkbox", buffer = true }
)
