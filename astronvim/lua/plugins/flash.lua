return {
	"folke/flash.nvim",
	keys = {
		{ "<C-s>", mode = { "c" }, false },
		{ "r", mode = { "o" }, false },
		{ "R", mode = { "o", "x" }, false },
		{ "s", mode = { "n", "o", "x" }, false },
		{ "S", mode = { "n", "o", "x" }, false },
		{
			"/",
			mode = { "n", "o", "x" },
			function() require("flash").jump() end,
			desc = "Flash Search",
		},
		{
			"?",
			mode = { "n", "o", "x" },
			function() require("flash").treesitter() end,
			desc = "Flash Treesitter",
		},
	},
	opts = {
		search = {
			multi_window = false,
			mode = "search",
		},
		jump = {
			history = true,
			register = true,
			nohlsearch = true,
		},
		modes = {
			search = {
				enabled = true,
			},
			char = {
				enabled = false,
			},
		},
		continue = true,
	},
	config = function(_, opts)
		require("flash").setup(opts)
	end,
}
