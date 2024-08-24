return {
	"lukas-reineke/indent-blankline.nvim",
	event = "User AstroFile",
	opts = {
		indent = {
			char = "│",
			tab_char = "│",
		},
		scope = {
			enabled = true,
			show_start = true,
			show_end = true,
			highlight = { "Function", "Label" },
		},
		whitespace = {
			remove_blankline_trail = true,
		},
	},
	config = function(_, opts)
		require("ibl").setup(opts)
	end,
}
