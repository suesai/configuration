local function get_visual_selection()
	-- this will exit visual mode
	-- use 'gv' to reselect the text
	local _, csrow, cscol, cerow, cecol
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "" then
		-- if we are in visual mode use the live position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("."))
		_, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
		if mode == "V" then
			-- visual line doesn't provide columns
			cscol, cecol = 0, 999
		end
		-- exit visual mode
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	else
		-- otherwise, use the last known visual position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
		_, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
	end
	-- swap vars if needed
	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end
	local lines = vim.fn.getline(csrow, cerow)
	local n = 0
	for _ in pairs(lines) do
		n = n + 1
	end
	if n <= 0 then
		return ""
	end
	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)
	return table.concat(lines, "\n")
end

local function is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end

local function get_git_root()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":h")
end

local cwd_opts
if is_git_repo() then
	cwd_opts = get_git_root()
else
	cwd_opts = vim.fn.getcwd()
end

local telescope_builtin = require("telescope.builtin")

return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>,", function() telescope_builtin.find_files({ cwd = cwd_opts }) end, desc = "Fuzzily find files" },
		{ "<leader><space>", telescope_builtin.current_buffer_fuzzy_find, desc = "Fuzzily search in current buffer" },
		{ "<leader>/", function() telescope_builtin.live_grep({ cwd = cwd_opts }) end, desc = "Fuzzily live grep" },
		{ "<leader>ds", telescope_builtin.lsp_document_symbols, desc = "[D]ocument [S]ymbols" },
		{
			"<leader><space>",
			function()
				local text = get_visual_selection()
				telescope_builtin.current_buffer_fuzzy_find({ default_text = text, cwd = cwd_opts })
			end,
			mode = "v",
			{ noremap = true, silent = true, desc = "Fuzzily search in current buffer" },
		},
		{
			"<leader>/",
			function()
				local text = get_visual_selection()
				telescope_builtin.live_grep({ default_text = text, cwd = cwd_opts })
			end,
			mode = "v",
			{ noremap = true, silent = true, desc = "Fuzzily live grep" },
		},
	},
	config = function()
		local telescope = require("telescope")
		local telescope_config = require("telescope.config")
		-- Clone the default Telescope configuration
		local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

		-- I want to search in hidden/dot files.
		table.insert(vimgrep_arguments, "--hidden")
		-- I don't want to search in the `.git` directory.
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		telescope.setup({
			defaults = {
				-- `hidden = true` is not supported in text grep commands.
				vimgrep_arguments = vimgrep_arguments,
				path_display = { "truncate" },
			},
			pickers = {
				find_files = {
					-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
		})

		telescope.load_extension("fzf")
	end
}
