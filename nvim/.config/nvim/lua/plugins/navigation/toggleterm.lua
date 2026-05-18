return {
	"akinsho/toggleterm.nvim",

	keys = {
		{ "<C-x>", "<cmd>ToggleTerm<cr>", desc = "Toggle the terminal" },
		-- { "<leader>g", "<cmd>lua _lazygit_toggle()<cr>", desc = "Open lazygit" },
	},

	config = function()
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			dir = "git_dir",
			direction = "float",
			float_opts = {
				border = "double",
			},
			-- function to run on opening the terminal
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			-- function to run on closing the terminal
			on_close = function(term)
				vim.cmd("startinsert!")
			end,
		})

		function _lazygit_toggle() 
            lazygit:toggle()
		end

		-- function _G.set_terminal_keymaps()
		-- 	local opts = { buffer = 0 }
		-- 	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
		-- end
		-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		require("toggleterm").setup({
			size = function()
				if vim.o.columns > 170 then
					return vim.o.columns * 0.3
				else
					return 15
				end
			end,
			direction = vim.o.columns > 170 and "vertical" or "horizontal",
			shade_terminals = true,
			insert_mappings = false,
			open_mapping = [[<c-x>]],
		})
	end,
}
