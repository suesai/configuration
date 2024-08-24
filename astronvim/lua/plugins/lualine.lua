return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		require("lualine").setup {
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1,
					}
				},
				lualine_x = {
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = { "encoding", "fileformat", "filetype" },
				lualine_z = { "progress", "location" },
			}
		}
	end
}
