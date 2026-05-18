return {
	{
		"L3MON4D3/LuaSnip",
		event = { "BufRead", "BufNewFile" },
		config = function()
			require("luasnip").config.set_config({
				history = false,
				enable_autosnippets = true,
				region_check_events = "InsertEnter",
				delete_check_events = "InsertLeave",
				require("luasnip.loaders.from_vscode").lazy_load({
					include = { "lua", "markdown", "md", "python", "c", "typescript", "javascript", "react", "matlab" },
				}),
			})

			local ls = require("luasnip")

			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-h>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	},
}
