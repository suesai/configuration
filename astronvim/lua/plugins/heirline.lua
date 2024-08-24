if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
	{
		"AstroNvim/astroui",
		---@type AstroUIOpts
		opts = {
			icons = {
				VimIcon = "",
				ScrollText = "",
				GitBranch = "",
				GitAdd = "",
				GitChange = "",
				GitDelete = "",
			},
			status = {
				colors = function(hl)
					local get_hlgroup = require("astroui").get_hlgroup
					local comment_fg = get_hlgroup("Comment").fg
					hl.git_branch_fg = comment_fg
					hl.git_added = comment_fg
					hl.git_changed = comment_fg
					hl.git_removed = comment_fg
					hl.blank_bg = get_hlgroup("Folded").fg
					-- hl.file_info_bg   = get_hlgroup("Visual").bg
					hl.nav_icon_bg = get_hlgroup("String").fg
					hl.nav_fg = hl.nav_icon_bg
					hl.folder_icon_bg = get_hlgroup("Error").fg
					return hl
				end,
				attributes = {
					mode = { bold = true },
				},
				icon_highlights = {
					file_icon = {
						statusline = false,
					},
				},
			},
		},
	},
	{
		"rebelot/heirline.nvim",
		opts = function(_, opts)
			opts.winbar = nil

			local status = require("astroui.status")
			opts.statusline = {
				hl = { fg = "fg", bg = "bg" },
				status.component.mode({
					mode_text = {
						icon = { kind = "VimIcon", padding = { right = 1, left = 1 } },
					},
					surround = {
						color = function() return { main = status.hl.mode_bg() } end,
					},
					padding = { right = 1 },
				}),
				status.component.git_branch({
					git_branch = { padding = { left = 1 } },
					surround = { separator = "none" },
				}),
				status.component.git_diff({
					padding = { left = 1 },
					surround = { separator = "none" },
				}),
				status.component.diagnostics({
					surround = { separator = "right" },
					padding = { right = 1 },
				}),
				status.component.fill(),
				status.component.cmd_info(),
				status.component.fill(),
				status.component.builder({
					{
						provider = function()
							return (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
						end,
						update = {
							"BufEnter",
						},
					},
					padding = { left = 1, right = 1 },
				}),
				status.component.builder({
					{
						provider = function() return vim.bo.fileformat end,
						update = {
							"BufEnter",
						},
					},
					padding = { left = 1, right = 1 },
				}),
				status.component.nav(),
			}
		end,
	},
}
