return {
	"hrsh7th/nvim-cmp",
	-- event = { "BufReadPost", "BufNewFile" },
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		{
			"saadparwaiz1/cmp_luasnip",
			dependencies = {
				"L3MON4D3/LuaSnip",
				dependencies = {
					"rafamadriz/friendly-snippets",
				},
				-- opts = {
				-- 	history = false,
				-- },
				config = function()
					local luasnip_fix_augroup = vim.api.nvim_create_augroup("MyLuaSnipHistory", { clear = true })
					vim.api.nvim_create_autocmd("ModeChanged", {
						pattern = '*',
						callback = function()
							if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
								and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
								and not require('luasnip').session.jump_active
							then
								require('luasnip').unlink_current()
							end
						end,
						group = luasnip_fix_augroup
					})
				end,
			}
		},
	},
	config = function()
		local luasnip = require("luasnip")
		local cmp = require("cmp")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			preselect = cmp.PreselectMode.None,
			-- completion = {
			-- 	autocomplete = false,
			-- },
			experimental = {
				ghost_text = true,
			},
			-- configure how nvim-cmp interacts with snippet engine
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "buffer" },
			}),
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- they way you will only jump inside the snippet region
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-y>"] = {
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					i = cmp.mapping.confirm({ select = false }),
					s = cmp.mapping.confirm({ select = false }),
				},

				['<C-e>'] = {
					i = cmp.mapping.abort(),
					s = cmp.mapping.abort(),
				},

				["<Down>"] = {
					i = function() end,
					s = function() end,
				},
				["<Up>"] = {
					i = function() end,
					s = function() end,
				},
			}),
		})

		-- cmp.setup.cmdline({'/', '?'}, {
		-- 	mapping = cmp.mapping.preset.cmdline(),
		-- 	sources = {
		-- 		{ name = 'buffer' },
		-- 	}
		-- })

		cmp.setup.cmdline(":", {
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" }
			}),
			mapping = cmp.mapping.preset.cmdline({
				["<C-n>"] = {
					c = function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end
				},

				["<C-p>"] = {
					c = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end
				},

				["<C-y>"] = {
					c = cmp.mapping.confirm({ select = false })
				},

				["<C-e>"] = {
					c = cmp.mapping.abort()
				},

				["<C-z>"] = {
					c = function() end
				},
				["<Tab>"] = {
					c = function() end
				},
				["<S-Tab>"] = {
					c = function() end
				},
			}),
		})
	end,
}

