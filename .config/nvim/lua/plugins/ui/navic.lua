return {
	"SmiteshP/nvim-navic",
	dependencies = "neovim/nvim-lspconfig",
	-- lazy = true,
	opts = {},
	config = function(_, opts)
		require("nvim-navic").setup(opts)
	end,
}
