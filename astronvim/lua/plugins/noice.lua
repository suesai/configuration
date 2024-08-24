return {
	"folke/noice.nvim",
	opts = function(_, opts)
		local utils = require "astrocore"
		return utils.extend_tbl(opts, {
			presets = {
				lsp_doc_border = true,
			},
		})
	end,
}
