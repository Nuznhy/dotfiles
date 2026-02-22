return {
	"numToStr/Comment.nvim",
	event = { "BufRead", "BufNewFile" },
	lazy = true,
	opts = {},
	config = function(_, opts)
		require("Comment").setup(opts)
	end,
}
