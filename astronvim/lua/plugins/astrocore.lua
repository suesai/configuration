-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- Configure core features of AstroNvim
		features = {
			large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
			autopairs = true, -- enable autopairs at start
			cmp = true, -- enable completion at start
			diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
			highlighturl = true, -- highlight URLs at start
			notifications = true, -- enable notifications at start
		},
		-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
		diagnostics = {
			virtual_text = true,
			underline = true,
		},
		-- vim options can be configured here
		options = {
			opt = { -- vim.opt.<key>
				autowrite = true,
				clipboard = vim.env.SSH_TTY and "" or "unnamedplus",
				completeopt = "menu,menuone,noselect",
				conceallevel = 2,
				confirm = true,
				cursorline = true,
				expandtab = false,
				exrc = true,
				fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1",
				fillchars = {
					foldopen = "",
					foldclose = "",
					fold = " ",
					foldsep = " ",
					diff = "╱",
					eob = " ",
				},
				foldlevel = 99,
				foldmethod = "indent",
				foldtext = "v:lua.require'util'.foldtext()",
				ignorecase = true,
				inccommand = "nosplit",
				incsearch = false,
				jumpoptions = "stack",
				laststatus = 3,
				linebreak = true,
				list = true,
				listchars = {
					tab = " ",
					space = " ",
					multispace = "·",
					lead = "·",
					leadmultispace = "·",
					trail = "·",
					extends = "›",
					precedes = "‹",
					nbsp = "␣",
					eol = "󰌑",
				},
				mouse = "a",
				number = true,
				pumblend = 10,
				pumheight = 10,
				relativenumber = true,
				scrolloff = 4,
				sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
				shiftwidth = 8,
				showmode = false,
				showtabline = 0,
				sidescrolloff = 8,
				signcolumn = "yes",
				smartcase = true,
				smartindent = true,
				softtabstop = 8,
				spell = false,
				splitbelow = true,
				splitkeep = "screen",
				splitright = true,
				statuscolumn = [[%!v:lua.require'util'.statuscolumn()]],
				tabstop = 8,
				termguicolors = true,
				timeoutlen = vim.g.vscode and 1000 or 300,
				undofile = true,
				undolevels = 10000,
				updatetime = 200,
				virtualedit = "block",
				wildmode = "longest:full,full",
				winminwidth = 5,
				wrap = false,
			},
			g = { -- vim.g.<key>
				-- configure global vim variables (vim.g)
				-- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
				-- This can be found in the `lua/lazy_setup.lua` file
				autoformat = false,
				bigfile_size = 1024 * 1024 * 1.5,
				bookmark_save_per_working_dir = 1,
				bookmark_auto_save = 1,
				deprecation_warnings = false,
				lazygit_config = true,
				lazyvim_picker = "auto",
				lazyvim_statuscolumn = {
					folds_open = false,
					folds_githl = false,
				},
				markdown_recommended_style = 0,
				root_spec = { "lsp", { ".git", "lua" }, "cwd" },
				trouble_lualine = true,
			},
		},
		-- Mappings can be configured through AstroCore as well.
		-- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
		mappings = {
			-- first key is the mode
			n = {
				-- second key is the lefthand side of the map

				-- tables with just a `desc` key will be registered with which-key if it's installed this is useful for naming menus
				-- ["<Leader>b"] = { desc = "Buffers" },

				-- setting a mapping to false will disable it
				-- ["<C-S>"] = false,

				["<A-j>"] = {
					"<cmd>m .+1<cr>==",
					desc = "Move Down",
				},
				["<A-k>"] = {
					"<cmd>m .-2<cr>==",
					desc = "Move Up",
				},
			},
			i = {
				["<A-j>"] = {
					"<esc><cmd>m .+1<cr>==gi",
					desc = "Move Down",
				},
				["<A-k>"] = {
					"<esc><cmd>m .-2<cr>==gi",
					desc = "Move Up",
				},
			},
			v = {
				["<A-j>"] = {
					":m '>+1<cr>gv=gv",
					desc = "Move Down",
				},
				["<A-k>"] = {
					":m '<-2<cr>gv=gv",
					desc = "Move Up",
				},
				["<"] = {
					"<gv",
					desc = "Decrease Indentation",
				},
				[">"] = {
					">gv",
					desc = "Increase Indentation",
				},
			},
		},
	},
}
