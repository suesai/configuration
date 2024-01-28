local function is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")

	return vim.v.shell_error == 0
end

local function get_git_root()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":h")
end

local cwd_opts = {}
if is_git_repo() then
	cwd_opts = {
		cmd = get_git_root(),
	}
else
	cwd_opts = {
		cwd = vim.fn.getcwd()
	}
end

local telescope_builtin = require("telescope.builtin")

return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>,", function() telescope_builtin.find_files(cwd_opts) end, desc = "Fuzzily find files" },
		{ "<leader><space>", telescope_builtin.current_buffer_fuzzy_find, desc = "Fuzzily search in current buffer" },
		{ "<leader>/", function() telescope_builtin.live_grep(cwd_opts) end, desc = "Fuzzily live grep" },
		{ "<leader>ds", telescope_builtin.lsp_document_symbols, desc = "[D]ocument [S]ymbols" },
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
