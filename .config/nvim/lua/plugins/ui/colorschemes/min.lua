return {
    'datsfilipe/min-theme.nvim',
    opts={
    -- (note: if your configuration sets vim.o.background the following option will do nothing!)
    theme = 'dark', -- String: 'dark' or 'light', determines the colorscheme used
    transparent = true, -- Boolean: Sets the background to transparent
    italics = {
        comments = true, -- Boolean: Italicizes comments
        keywords = true, -- Boolean: Italicizes keywords
        functions = true, -- Boolean: Italicizes functions
        strings = true, -- Boolean: Italicizes strings
        variables = true, -- Boolean: Italicizes variables
    },
    overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
}}
