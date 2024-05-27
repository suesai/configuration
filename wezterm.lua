-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Tomorrow Night"

config.font = wezterm.font("IntoneMono Nerd Font Mono")
config.font_size = 14

config.enable_tab_bar = true

config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.75
-- config.macos_window_background_blur = 8

-- and finally, return the configuration to wezterm
return config
