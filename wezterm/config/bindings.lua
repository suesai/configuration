local wezterm   = require("wezterm")
local platform  = require("utils.platform")
local backdrops = require('utils.backdrops')
local act       = wezterm.action

local mod = {}

if platform.is_mac then
	mod.SUPER     = "SUPER"
	mod.SUPER_REV = "SUPER|CTRL"
	mod.MODIFIER  = "CTRL|SHIFT"
elseif platform.is_win or platform.is_linux then
	mod.SUPER     = "ALT" -- to not conflict with Windows key shortcuts
	mod.SUPER_REV = "ALT|CTRL"
	mod.MODIFIER  = "CTRL|SHIFT"
end

-- stylua: ignore
local keys = {
	-- misc/useful --
	{ key = "[",  mods = mod.MODIFIER,  action = act.ActivateCopyMode },
	{ key = "p",  mods = mod.MODIFIER,  action = act.ActivateCommandPalette },
	{ key = "d",  mods = mod.MODIFIER,  action = act.DetachDomain("CurrentPaneDomain") },
	{ key = "f",  mods = mod.SUPER,     action = act.Search({ CaseInSensitiveString = "" }) },

	-- copy/paste --
	{ key = "c",  mods = mod.SUPER,     action = act.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "v",  mods = mod.SUPER,     action = act.PasteFrom("Clipboard") },

	-- tabs --
	-- tabs: spawn+close
	{ key = "t",  mods = mod.SUPER,     action = act.SpawnTab("DefaultDomain") },
	{ key = "w",  mods = mod.SUPER,     action = act.CloseCurrentTab({ confirm = false }) },

	-- tabs: navigation
	{ key = "[",  mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
	{ key = "]",  mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
	{ key = "[",  mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
	{ key = "]",  mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

	-- tab: title
	{ key = "0",  mods = mod.SUPER,     action = act.EmitEvent("tabs.manual-update-tab-title") },
	{ key = "0",  mods = mod.SUPER_REV, action = act.EmitEvent("tabs.reset-tab-title") },

	-- window --
	-- window: spawn windows
	{ key = "n",  mods = mod.SUPER,     action = act.SpawnWindow },

	-- panes --
	-- panes: split panes
	{ key = "\\", mods = mod.MODIFIER,  action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-",  mods = mod.MODIFIER,  action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- panes: zoom+close pane
	{ key = "m",  mods = mod.MODIFIER,  action = act.TogglePaneZoomState },
	{ key = "x",  mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) },

	-- panes: navigation
	{ key = "k",  mods = mod.MODIFIER,  action = act.ActivatePaneDirection("Up") },
	{ key = "j",  mods = mod.MODIFIER,  action = act.ActivatePaneDirection("Down") },
	{ key = "h",  mods = mod.MODIFIER,  action = act.ActivatePaneDirection("Left") },
	{ key = "l",  mods = mod.MODIFIER,  action = act.ActivatePaneDirection("Right") },

	-- panes: scroll pane
	{ key = "PageUp",     mods = "NONE",        action = act.ScrollByPage(-0.75) },
	{ key = "PageDown",   mods = "NONE",        action = act.ScrollByPage(0.75) },

	-- panes: resize
	{ key = "LeftArrow",  mods = mod.MODIFIER,  action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = mod.MODIFIER,  action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "DownArrow",  mods = mod.MODIFIER,  action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "UpArrow",    mods = mod.MODIFIER,  action = act.AdjustPaneSize({ "Up", 5 }) },

	-- panes: iterate
	{ key = "1",  mods = mod.SUPER,     action = act.ActivateTab(0) },
	{ key = "2",  mods = mod.SUPER,     action = act.ActivateTab(1) },
	{ key = "3",  mods = mod.SUPER,     action = act.ActivateTab(2) },
	{ key = "4",  mods = mod.SUPER,     action = act.ActivateTab(3) },
	{ key = "5",  mods = mod.SUPER,     action = act.ActivateTab(4) },
	{ key = "6",  mods = mod.SUPER,     action = act.ActivateTab(5) },
	{ key = "7",  mods = mod.SUPER,     action = act.ActivateTab(6) },
	{ key = "8",  mods = mod.SUPER,     action = act.ActivateTab(7) },
	{ key = "9",  mods = mod.SUPER,     action = act.ActivateTab(8) },

	-- background controls --
	{ key = ",",  mods = mod.SUPER,     action = wezterm.action_callback(
		function(window, _)
			backdrops:random(window)
		end
	)},
	{ key = ".",  mods = mod.SUPER,     action = act.InputSelector({
		title = "InputSelector: Select Background",
		choices = backdrops:choices(),
		fuzzy = true,
		fuzzy_description = "Select Background: ",
		action = wezterm.action_callback(function(window, _, idx)
			if not idx then
				return
			end
			---@diagnostic disable-next-line: param-type-mismatch
			backdrops:set_img(window, tonumber(idx))
		end),
	})},
	{ key = "/", mods = mod.SUPER, action = wezterm.action_callback(
		function(window, _)
			backdrops:toggle_focus(window)
		end
	)},
}

local mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

return {
	disable_default_key_bindings = true,
	-- disable_default_mouse_bindings = true,
	keys = keys,
	mouse_bindings = mouse_bindings,
}
