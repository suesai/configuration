return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	opts = {
		ensure_installed = "all",
		ignore_innstall = {
			"scfg",
			"smali",
			"unison",
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = false,
		},
		textobjects = {
			select = {
				enable = true,
				include_surrounding_whitespace = false,
			},
			swap = {
				enable = true,
			}
		}
	}
}
