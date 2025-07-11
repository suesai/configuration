package.path = "/etc/wezterm/?.lua;/etc/wezterm/?/init.lua"

local config = require("config")

require("utils.backdrops")
	:set_files()
	-- :set_focus("#000000")
	:random()

require("events.right-status").setup()
require("events.left-status").setup()
require("events.tab-title").setup()
require("events.new-tab-button").setup()
require("events.general").setup()

require("session-manager.session-manager").setup()

return config:init()
	:append(require("config.appearance"))
	:append(require("config.bindings"))
	:append(require("config.domains"))
	:append(require("config.fonts"))
	:append(require("config.general"))
	:append(require("config.launch")).options
