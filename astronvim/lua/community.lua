-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	{ import = "astrocommunity.bars-and-lines.lualine-nvim" },
	{ import = "astrocommunity.color.vim-highlighter" },
	{ import = "astrocommunity.colorscheme.vscode-nvim" },
	{ import = "astrocommunity.completion.cmp-cmdline" },
	{ import = "astrocommunity.editing-support.nvim-treesitter-context" },
	{ import = "astrocommunity.indent.indent-blankline-nvim" },
	{ import = "astrocommunity.motion.mini-surround" },
	{ import = "astrocommunity.pack.bash" },
	{ import = "astrocommunity.pack.cmake" },
	{ import = "astrocommunity.pack.cpp" },
	{ import = "astrocommunity.pack.docker" },
	{ import = "astrocommunity.pack.go" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.java" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.markdown" },
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.sql" },
	{ import = "astrocommunity.pack.toml" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.xml" },
	{ import = "astrocommunity.recipes.telescope-lsp-mappings" },
	{ import = "astrocommunity.search.nvim-spectre" },
	{ import = "astrocommunity.utility.noice-nvim" },
}
