if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{ "hrsh7th/cmp-cmdline", lazy = true },
	},
	opts = function()
		local cmp, luasnip = require("cmp"), require("luasnip")

		local has_words_before = function()
			local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end
		local is_visible = function()
			return cmp.core.view:visible() or vim.fn.pumvisible() == 1
		end

		local fallback = function(fallback_func) fallback_func() end
		local confirm  = function() cmp.mapping.confirm({ select = false }) end
		local abort    = function() cmp.mapping.abort() end

		local i_next_item = function(fallback_func)
			if is_visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif vim.api.nvim_get_mode().mode ~= "c" and luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback_func()
			end
		end
		local i_prev_item = function(fallback_func)
			if is_visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif vim.api.nvim_get_mode().mode ~= "c" and luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback_func()
			end
		end

		cmp.setup({
			preselect = cmp.PreselectMode.None,
			completion = {
				completeopt = "menu,menuone,noinsert,noselect,preview",
			},
			mapping = {
				["<C-n>"] = cmp.mapping(i_next_item,  { "i" }),
				["<C-p>"] = cmp.mapping(i_prev_item,  { "i" }),
				["<C-y>"] = cmp.mapping(confirm,      { "i" }),
				["<C-e>"] = cmp.mapping(abort,        { "i" }),

				["<C-space>"] = cmp.mapping(fallback, { "i" }),
				["<C-k>"]     = cmp.mapping(fallback, { "i" }),
				["<C-j>"]     = cmp.mapping(fallback, { "i" }),
				["<CR>"]      = cmp.mapping(fallback, { "i" }),
				["<Tab>"]     = cmp.mapping(fallback, { "i", "s" }),
				["<S-Tab>"]   = cmp.mapping(fallback, { "i", "s" }),
			},
		})

		local c_next_item = function(fallback_func)
			if is_visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback_func()
			end
		end
		local c_prev_item = function(fallback_func)
			if is_visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback_func()
			end
		end

		cmp.setup.cmdline({ ":", "/" }, {
			mapping = {
				["<C-n>"] = cmp.mapping(c_next_item, { "c" }),
				["<C-p>"] = cmp.mapping(c_prev_item, { "c" }),
				["<C-y>"] = cmp.mapping(confirm,     { "c" }),
				["<C-e>"] = cmp.mapping(abort,       { "c" }),

				["<C-space>"] = cmp.mapping(fallback, { "c" }),
				["<C-k>"]     = cmp.mapping(fallback, { "c" }),
				["<C-j>"]     = cmp.mapping(fallback, { "c" }),
				["<C-z>"]     = cmp.mapping(fallback, { "c" }),
				["<CR>"]      = cmp.mapping(fallback, { "c" }),
			},
		})
	end,
}
