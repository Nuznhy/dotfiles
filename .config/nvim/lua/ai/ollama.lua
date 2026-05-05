local Provider = {}

function Provider.new(opts)
  local self = setmetatable({}, { __index = Provider })
  self.opts = opts or {}
  return self
end

function Provider:complete(ctx, callback)
  local lines = vim.api.nvim_buf_get_lines(0, 0, ctx.cursor[1], false)
  local prompt = table.concat(lines, "\n")

  local body = vim.json.encode({
    model = "qwen3.5:9b",
    prompt = prompt,
    stream = false,
  })

  vim.system({
    "curl",
    "-s",
    "http://localhost:11434/api/generate",
    "-d",
    body,
  }, { text = true }, function(res)
    if res.code ~= 0 then
      callback({})
      return
    end

    local decoded = vim.json.decode(res.stdout)

    callback({
      {
        label = decoded.response,
        kind = 1,
        documentation = "Ollama",
      },
    })
  end)
end

return Provider
