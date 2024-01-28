return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig",
		{
			"williamboman/mason.nvim",
			opts = {
				ui = {
					check_outdated_packages_on_open = false
				}
			}
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = {
				ensure_installed = {
					-- formatter
					"asmfmt",
					"black",
					"clang-format",
					"cmakelang",
					"markdownlint",
					"prettier",
					"shfmt",
					"stylua",
					-- linter
					"cpplint",
					"jsonlint",
					-- "luacheck",
					"pylint",
					"shellcheck",
				}
			}
		},
		{
			"ray-x/lsp_signature.nvim",
			opts = {
				floating_window = false,
				hint_prefix = "🐼 ",
				toggle_key = "<C-k>",
			}
		},
	},
	config = function()
		-- local util = require("lspconfig.util")
		local servers = {
			asm_lsp = {},
			bashls = {},
			clangd = {
				-- root_dir = function(fname)
				-- 	return util.root_pattern(unpack(root_files))(fname) or vim.fn.getcwd()
				-- 	return vim.fn.getcwd()
				-- end
				cmd = {
					"clangd",
					"--function-arg-placeholders=0",
					-- "--background-index",
					"--completion-style=detailed",
					"--header-insertion=never",
					"--log=info",
				}
			},
			cmake = {},
			jsonls = {},
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			},
			marksman = {},
			perlnavigator = {},
			pyright = {},
			rust_analyzer = {},
		}

		local on_attach = function(_, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			local telescope_builtin = require("telescope.builtin")

			nmap("gd", telescope_builtin.lsp_definitions, "[G]oto [D]efinition")
			nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			nmap("gI", telescope_builtin.lsp_implementations, "[G]oto [I]mplementation")
			nmap("gy", telescope_builtin.lsp_type_definitions, "Goto T[y]pe Definition")
			nmap("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			-- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
			-- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
			-- nmap("<leader>wl", function()
			-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- end, "[W]orkspace [L]ist Folders")
			nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
			nmap("<leader>da", telescope_builtin.diagnostics, "[D]i[A]gnostics")
		end

		require("neoconf").setup()
		require("neodev").setup()
		require("mason").setup()
		local capabilities = require("cmp_nvim_lsp").default_capabilities({
			-- snippetSupport = false
		})
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		for server, config in pairs(servers) do
			require("lspconfig")[server].setup(
				vim.tbl_deep_extend("keep",
					{
						on_attach = on_attach,
						capabilities = capabilities
					},
					config
				)
			)
		end
	end
}
