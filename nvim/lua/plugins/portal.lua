return {
	"cbochs/portal.nvim",
	dependencies = {
		"cbochs/grapple.nvim",
		"ThePrimeagen/harpoon"
	},
	keys = {
		{ "<leader>o", "<cmd>Portal jumplist backward<cr>", desc = "[Portal] jumplist backward" },
		{ "<leader>i", "<cmd>Portal jumplist forward<cr>", desc = "[Portal] jumplist forward" },
		{ "<leader>;", "<cmd>Portal changelist backward<cr>", desc = "[Portal] changelist backward" },
		{ "<leader>'", "<cmd>Portal changelist forward<cr>", desc = "[Portal] changelist forward" },
	},
	opts = {
		max_results = 9,
		labels = {
			"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
		},
	},
}
