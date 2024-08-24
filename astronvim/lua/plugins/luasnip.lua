return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		{ "rafamadriz/friendly-snippets", lazy = true },
	},
	opts = {
		history = true,
		updateevents = "TextChanged,TextChangedI",
	},
	config = function()
		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = function()
				if
					require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
					and not require("luasnip").session.jump_active
				then
					require("luasnip").unlink_current()
				end
			end,
		})
	end,
}
