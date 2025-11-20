require("bookmarks"):setup({
	last_directory = {
		enable  = true,
		persist = true,
		mode    = "dir"
	},
	persist = "all",
	file_pick_mode = "parent",
	notify = {
		enable  = true,
		timeout = 3,
	},
})

require("full-border"):setup {
	type = ui.Border.ROUNDED,
}

require("git"):setup {}

require("starship"):setup {
	config_file = "/etc/non_exist_starship.toml",
}

require("yaziline"):setup {
	separator_style      = "angly",
	select_symbol        = "",
	yank_symbol          = "󰆐",
	filename_max_length  = 24,
	filename_trim_length = 6,
}

Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line {}
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	}
end, 500, Status.RIGHT)
