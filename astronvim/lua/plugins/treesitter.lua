return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = "all",

		highlight = {
			enable = true,
			use_languagetree = true,
		},

		ignore_install = {
			"scfg",
			"smali",
			"unison",
			"systemverilog"
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
	},
}
