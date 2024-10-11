return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"asm", "awk", "bash", "c", "cmake", "comment", "cpp", "css", "devicetree", "diff", "disassembly", "dockerfile", "doxygen", "fish",
			"git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "go", "html", "http", "ini",
			"java", "javascript", "jq", "jsdoc", "json", "json5", "jsonc", "kconfig", "kotlin", "latex", "llvm", "lua", "luadoc", "luap",
			"make", "markdown", "markdown_inline", "matlab", "meson", "nasm", "nginx", "ninja", "objdump", "passwd", "perl", "printf", "python", "regex", "rust",
			"scheme", "slint", "sql", "strace", "systemtap", "tmux", "toml", "typescript", "udev", "vim", "vimdoc", "xml", "yaml",
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
