-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local option = vim.opt
local global = vim.g

global.autoformat = false

option.fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1"
option.termencoding = "utf-8"
option.tabstop = 8
option.shiftwidth = 8
option.softtabstop = 8
option.expandtab = false
option.incsearch = false
option.listchars:append({
	-- tab = "→ ",
	-- tab = " ",
	tab = " ",
	space = " ",
	multispace = "·",
	lead = "·",
	leadmultispace = "·",
	trail = "·";
	extends = "›",
	precedes = "‹",
	-- nbsp = "␣",
	nbsp = "󱁐",
	-- eol = "↵",
	eol = "󰌑",
})
option.whichwrap:append("<,>")
option.exrc = true
option.completeopt = "menu,menuone,noinsert,noselect,preview"

