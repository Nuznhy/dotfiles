 local M = {}

 function M.setup()
   require('base16-colorscheme').setup {
     -- Background tones
     base00 = '#fffaf3', -- Default Background
     base01 = '#f2e9e1', -- Lighter Background (status bars)
     base02 = '#ecdfd3', -- Selection Background
     base03 = '#9e8e8b', -- Comments, Invisibles
     -- Foreground tones
     base04 = '#797593', -- Dark Foreground (status bars)
     base05 = '#575279', -- Default Foreground
     base06 = '#575279', -- Light Foreground
     base07 = '#575279', -- Lightest Foreground
     -- Accent colors
     base08 = '#b4637a', -- Variables, XML Tags, Errors
     base09 = '#286983', -- Integers, Constants
     base0A = '#56949f', -- Classes, Search Background
     base0B = '#d7827e', -- Strings, Diff Inserted
     base0C = '#1b627e', -- Regex, Escape Chars
     base0D = '#7e1f1b', -- Functions, Methods
     base0E = '#1b6f7e', -- Keywords, Storage
     base0F = '#e4cdd4', -- Deprecated, Embedded Tags
   }
 end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
