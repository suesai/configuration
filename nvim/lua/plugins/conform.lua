return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in viausl mode)"
		}
	},
	opts = {
		formatters_by_ft = {
			asm = { "asmfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			cmake = { "cmake_format" },
			fish = {},
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "markdownlint" },
			python = { "black" },
			sh = { "shfmt" },
		},
	},
}
