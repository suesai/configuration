local wez   = require("wezterm")
local umath = require("utils.math")
local Cells = require("utils.cells")

local nf = wez.nerdfonts
local attr = Cells.attr

local M = {}

local ICON_SEPARATOR = nf.oct_dash
local ICON_DATE = nf.fa_calendar

---@type string[]
local discharging_icons = {
	nf.md_battery_10,
	nf.md_battery_20,
	nf.md_battery_30,
	nf.md_battery_40,
	nf.md_battery_50,
	nf.md_battery_60,
	nf.md_battery_70,
	nf.md_battery_80,
	nf.md_battery_90,
	nf.md_battery,
}
---@type string[]
local charging_icons = {
	nf.md_battery_charging_10,
	nf.md_battery_charging_20,
	nf.md_battery_charging_30,
	nf.md_battery_charging_40,
	nf.md_battery_charging_50,
	nf.md_battery_charging_60,
	nf.md_battery_charging_70,
	nf.md_battery_charging_80,
	nf.md_battery_charging_90,
	nf.md_battery_charging,
}

---@type table<string, Cells.SegmentColors>
-- stylua: ignore
local colors = {
	date      = { fg = "#fab387", bg = "rgba(0, 0, 0, 0.4)" },
	battery   = { fg = "#f9e2af", bg = "rgba(0, 0, 0, 0.4)" },
	separator = { fg = "#74c7ec", bg = "rgba(0, 0, 0, 0.4)" }
}

local cells = Cells:new()

cells:add_segment("date_icon", ICON_DATE .. "  ", colors.date, attr(attr.intensity("Bold")))
	:add_segment("date_text", "", colors.date, attr(attr.intensity("Bold")))
	:add_segment("separator", " " .. ICON_SEPARATOR .. "  ", colors.separator)
	:add_segment("battery_icon", "", colors.battery)
	:add_segment("battery_text", "", colors.battery, attr(attr.intensity("Bold")))

---@return string, string
local function battery_info()
	-- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

	local charge = ""
	local icon = ""

	for _, b in ipairs(wez.battery_info()) do
		if "nan" == tostring(b.state_of_charge) then
			charge = "100%"
			if b.state == "Charging" then
				icon = charging_icons[10]
			else
				icon = discharging_icons[10]
			end
		else
			local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
			charge = string.format("%.0f%%", b.state_of_charge * 100)
			if b.state == "Charging" then
				icon = charging_icons[idx]
			else
				icon = discharging_icons[idx]
			end
		end
	end

	return charge, icon .. " "
end

M.setup = function()
	wez.on("update-right-status", function(window, _pane)
		local battery_text, battery_icon = battery_info()

		cells:update_segment_text("date_text", wez.strftime("%a %H:%M:%S"))
			:update_segment_text("battery_icon", battery_icon)
			:update_segment_text("battery_text", battery_text)

		window:set_right_status(wez.format(cells:render({ "date_icon", "date_text", "separator", "battery_icon", "battery_text" })))
	end)
end

return M