return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            views = {
                cmdline_popup = {
                    win_options = {
                        winhighlight = {
                            Normal = "NormalFloat",
                            FloatBorder = "FloatBorder",
                            FloatTitle = "FloatTitle",
                        },
                    },
                },

                popupmenu = {
                    win_options = {
                        winhighlight = {
                            Normal = "Pmenu",
                            FloatBorder = "FloatBorder",
                            CursorLine = "PmenuSel",
                        },
                    },
                },

                confirm = {
                    win_options = {
                        winhighlight = {
                            Normal = "NormalFloat",
                            FloatBorder = "FloatBorder",
                        },
                    },
                },

                hover = {
                    win_options = {
                        winhighlight = {
                            Normal = "NormalFloat",
                            FloatBorder = "FloatBorder",
                        },
                    },
                },
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function(_, opts)
            require("noice").setup(opts)

            for _, group in ipairs({
                "NoiceCmdlinePopup",
                "NoiceCmdlinePopupBorder",
                "NoiceCmdlinePopupBorderCmdline",
                "NoiceCmdlinePopupBorderSearch",
                "NoiceCmdlinePopupBorderHelp",
                "NoiceCmdlinePopupBorderLua",
                "NoiceCmdlinePopupBorderInput",
                "NoiceCmdlinePopupTitle",
            }) do
                vim.api.nvim_set_hl(0, group, { bg = "NONE" })
            end
        end,
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            background_colour = "#000000",
        }
    },
}
