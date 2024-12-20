local M = {}

local wez = require("wezterm")

M.setup = function()
	wez.on("gui-startup", function(cmd)
		local ratio  = 0.7
		local screen = wez.gui.screens().main
		local width, height = screen.width * ratio, screen.height * ratio
		local _, _, window = wez.mux.spawn_window(cmd or {
			position = { x = (screen.width - width) / 2, y = (screen.height - height) / 2 },
		})
		window:gui_window():set_inner_size(width, height)
	end)

	wez.on("gui-attached", function(_)
		local ratio  = 0.7
		local screen = wez.gui.screens().main
		local width, height = screen.width * ratio, screen.height * ratio
		for _, window in ipairs(wez.mux.all_windows()) do
			window:gui_window():set_position((screen.width - width) / 2, (screen.height - height) / 2)
			window:gui_window():set_inner_size(width, height)
		end
	end)
end

return M
