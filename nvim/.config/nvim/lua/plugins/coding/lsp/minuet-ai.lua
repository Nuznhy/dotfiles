local function ollama_available()
  local handle = io.popen("curl -s http://localhost:11434/api/tags")
  if not handle then return false end

  local result = handle:read("*a")
  handle:close()

  return result and result ~= ""
end

return {
    'milanglacier/minuet-ai.nvim',
    enabled = ollama_available(),
    config = function()
        require('minuet').setup {
            context_window = 512,
            provider = 'openai_fim_compatible',
            provider_options = {
                openai_fim_compatible = {
                    api_key = 'TERM',
                    name = 'Ollama',
                    end_point = 'http://localhost:11434/v1/completions',
                    model = 'qwen2.5-coder:3b',
                    optional = {
                        max_tokens = 56,
                        top_p = 0.9,
                    },
                },
            },
            virtualtext = {
                auto_trigger_ft = {},
                keymap = {
                    -- accept whole completion
                    accept = '<A-A>',
                    -- accept one line
                    accept_line = '<A-a>',
                    -- accept n lines (prompts for number)
                    -- e.g. "A-z 2 CR" will accept 2 lines
                    accept_n_lines = '<A-z>',
                    -- Cycle to prev completion item, or manually invoke completion
                    prev = '<A-[>',
                    -- Cycle to next completion item, or manually invoke completion
                    next = '<A-]>',
                    dismiss = '<A-e>',
                },
            },
        }
    end,
}
