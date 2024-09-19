return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"asm", "bash", "c", "cmake", "cpp", "css", "diff", "disassembly", "dockerfile", "doxygen", "fish",
			"git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "go", "html", "http",
			"java", "javascript", "jq", "jsdoc", "json", "json5", "kconfig", "kotlin", "lua", "luadoc",
			"make", "markdown", "meson", "ninja", "objdump", "perl", "printf", "python", "regex", "rust",
			"sql", "strace", "systemtap", "toml", "typescript", "vim", "vimdoc", "xml", "yaml",
		},

		highlight = {
			enable = true,
			use_languagetree = true,
		},

		ignore_install = {
			"scfg",
			"smali",
			"unison",
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
