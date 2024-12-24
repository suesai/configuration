local M = {}

local wez = require("wezterm")

local center_window = function(window)
	local ratio   = 0.7
	local screens = wez.gui.screens()
	local active  = screens.active
	local width, height = active.width * ratio, active.height * ratio
	local row,   col    = (active.height - height) / 2, (active.width - width) / 2

	if 0 ~= active.x then
		for key, value in pairs(screens.by_name) do
			if key ~= active.name then
				local scale = value.scale / active.scale
				row = row * scale
				col = col * scale + value.width
				break
			end
		end
	end

	window:set_position(col, row)
	window:set_inner_size(width, height)
end

M.setup = function()
	wez.on("gui-startup", function(cmd)
		local _, _, window = wez.mux.spawn_window(cmd or {})
		center_window(window:gui_window())
	end)

	wez.on("gui-attached", function(_)
		for _, window in ipairs(wez.mux.all_windows()) do
			center_window(window:gui_window())
		end
	end)

	wez.on("max_window", function(window)
		window:maximize()
	end)

	wez.on("center_window", function(window)
		center_window(window)
	end)
end

return M
