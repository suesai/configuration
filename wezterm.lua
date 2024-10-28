-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = "Tomorrow Night"
config.font = wezterm.font("IntoneMono Nerd Font Mono")
config.font_size = 14

config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 5,
}

-- config.text_background_opacity = 0.8

config.ssh_domains = {
	{
		name = "rlk",
		remote_address = "192.168.0.104:8822",
		username = "root",
		remote_wezterm_path = "/usr/bin/wezterm",
	}
}

config.unix_domains = {
	{
		name = "unix"
	}
}

config.default_gui_startup_args = { "connect", "unix" }

config.keys = {
	{
		key = "D",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DetachDomain "CurrentPaneDomain"
	}
}

config.scrollback_lines = 10240
config.enable_scroll_bar = true

-- and finally, return the configuration to wezterm
return config
