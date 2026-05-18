local langs = require("langs")

-- Enable all configured servers
for _, server in ipairs(langs.servers) do
  vim.lsp.enable(server)
end
