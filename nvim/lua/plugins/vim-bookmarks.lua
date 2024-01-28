return {
	"MattesGroeger/vim-bookmarks",
	dependencies = {
		"tom-anders/telescope-vim-bookmarks.nvim",
		config = function()
			require("telescope").load_extension("vim_bookmarks")
		end
	},
	keys = {
		{ "<leader>mt", "<cmd>BookmarkToggle<cr>", desc = "Bookmark toggle" },
		{ "<leader>ma", "<cmd>Telescope vim_bookmarks<cr>", desc = "Bookmark all" },
		{ "<leader>mc", "<cmd>BookmarkClear<cr>", desc = "Bookmark clear" },
		{ "<leader>mx", "<cmd>BookmarkClearAll<cr>", desc = "Bookmark clear all" },
		{ "mm", false },
		{ "mi", false },
		{ "mn", false },
		{ "mp", false },
		{ "ma", false },
		{ "mc", false },
		{ "mx", false },
		{ "mkk", false },
		{ "mjj", false },
	}
}
