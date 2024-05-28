return {
	"folke/flash.nvim",
	keys = {
		{ "<c-s>", mode = { "c" }, false },
		{ "r", mode = { "o" }, false },
		{ "R", mode = { "o", "x" }, false },
		{ "s", mode = { "n", "o", "x" }, false },
		{ "S", mode = { "n", "o", "x" }, false },
		-- { "<leader>s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
		-- { "<leader>S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" }
	},
	config = function()
		require("flash").setup({
			modes = {
				search = {
					enabled = true,
				},
				char = {
					enabled = false,
					-- jump_labels = true,
				}
			}
		})
	end
}
