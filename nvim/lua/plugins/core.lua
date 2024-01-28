return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "vscode",
		},
	},
	{ import = "lazyvim.plugins.extras.formatting.prettier" },
	{ import = "lazyvim.plugins.extras.lang.clangd" },
	{ import = "lazyvim.plugins.extras.lang.cmake" },
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.lang.markdown" },
	{ import = "lazyvim.plugins.extras.lang.python" },
	-- { import = "lazyvim.plugins.extras.lang.rust" },
	-- { import = "lazyvim.plugins.extras.lsp.none-ls" },
	-- { import = "lazyvim.plugins.extras.util.project" },
	-- { import = "lazyvim.plugins.extras.ui.mini-animate" },
}
