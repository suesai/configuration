return {
	"nvim-neo-tree/neo-tree.nvim",
	keys = {
		{
			"<leader>fE",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").root() })
			end,
			desc = "Filesystem Explorer (root dir)",
		},
		{
			"<leader>fe",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
			end,
			desc = "Filesystem Explorer (cwd)",
		},
		{ "<leader>e", "<leader>fe", desc = "Filesystem Explorer (cwd)", remap = true },
		{ "<leader>E", "<leader>fE", desc = "Filesystem Explorer (root dir)", remap = true },
		{
			"<leader>se",
			function()
				require("neo-tree.command").execute({ toggle = true, source = "document_symbols" })
			end,
			desc = "Document Symbols Explorer",
		}
	},
	opts = {
		window = {
			mappings = {
				["c"] = "close_node",
				["C"] = "close_all_nodes",
				-- ["z"] = "expand_node",
				-- ["Z"] = "expand_all_nodes",
			},
		},
		filesystem = {
			fileterd_items = {
				never_show = {
					".DS_Store",
					"thumbs.db",
				},
				always_show = {
					".gitignored",
					".clang-format",
					".clangd",
				},
			}
		},
		document_symbols = {
			follow_cursor = true,
		}
	},
}
