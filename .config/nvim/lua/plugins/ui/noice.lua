local function transparent_noice()
  local groups = {
    "NoiceCmdlinePopup",
    "NoiceCmdlinePopupBorder",
    "NoiceCmdlinePopupBorderCmdline",
    "NoiceCmdlinePopupBorderSearch",
    "NoiceCmdlinePopupBorderHelp",
    "NoiceCmdlinePopupBorderLua",
    "NoiceCmdlinePopupBorderInput",
    "NoiceCmdlinePopupTitle",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end
end

transparent_noice()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = transparent_noice,
})
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
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            background_colour = "#000000",
        }
    },
}
