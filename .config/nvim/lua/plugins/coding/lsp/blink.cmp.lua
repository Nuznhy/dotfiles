return {
    'saghen/blink.cmp',
    dependencies = {
        { 'rafamadriz/friendly-snippets' },
        { 'brenoprata10/nvim-highlight-colors' }
    },
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        signature = { enabled = true },
        fuzzy = {
            sorts = {
                'exact',
                'score',
                'sort_text',
            },
        },
        sources = {
            default = { 'lsp', 'path', 'buffer', 'snippets' },
        },
        completion = {
            list = { max_items = 50 },
            trigger = { prefetch_on_insert = false },
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
            menu = {
                auto_show = true,
                draw = {
                    treesitter = { "lsp" },
                    columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
                    components = {
                        -- customize the drawing of kind icons
                        kind_icon = {
                            text = function(ctx)
                                -- default kind icon
                                local icon = ctx.kind_icon
                                -- if LSP source, check for color derived from documentation
                                if ctx.item.source_name == "LSP" then
                                    local color_item = require("nvim-highlight-colors").format(ctx.item.documentation,
                                        { kind = ctx.kind })
                                    if color_item and color_item.abbr ~= "" then
                                        icon = color_item.abbr
                                    end
                                end
                                return icon .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                -- default highlight group
                                local highlight = "BlinkCmpKind" .. ctx.kind
                                -- if LSP source, check for color derived from documentation
                                if ctx.item.source_name == "LSP" then
                                    local color_item = require("nvim-highlight-colors").format(ctx.item.documentation,
                                        { kind = ctx.kind })
                                    if color_item and color_item.abbr_hl_group then
                                        highlight = color_item.abbr_hl_group
                                    end
                                end
                                return highlight
                            end,
                        },
                    },
                },
            }
        }
    },
    opts_extend = { "sources.default" }
}
