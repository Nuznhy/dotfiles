vim.lsp.config('biome', {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = { "json", "jsonc" },
  root_markers = { "biome.json" },
})

return {
    servers = { "biome" },
    parsers = { "json", "json5" } 
}
