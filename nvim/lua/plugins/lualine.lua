return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		opts.sections.lualine_z = {}
		table.insert(opts.sections.lualine_z, "progress")
		table.insert(opts.sections.lualine_z, "location")
		opts.sections.lualine_y = {}
		table.insert(opts.sections.lualine_y, "encoding")
		table.insert(opts.sections.lualine_y, "fileformat")
		table.insert(opts.sections.lualine_y, "filetype")
		-- table.insert(opts.sections.lualine_x, "selectioncount")
	end
}
