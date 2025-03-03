local wez       = require("wezterm")
local mux       = wez.mux
local platform  = require("utils.platform")
local M         = {}


--- Saves data to a JSON file.
-- @param data table: The JSON data to be saved.
-- @param file_path string: The file path where the JSON file will be saved.
-- @return boolean: true if saving was successful, false otherwise.
local function save_to_json_file(data, file_path)
	if not data then
		wez.log_info("No JSON data to log.")
		return false
	end

	local file = io.open(file_path, "w")
	if file then
		file:write(wez.json_encode(data))
		file:close()
		return true
	else
		return false
	end
end


--- Loads data from a JSON file.
-- @param file_path string: The file path from which the JSON data will be loaded.
-- @return table or nil: The loaded data as a Lua table, or nil if loading failed.
local function load_from_json_file(file_path)
	local file = io.open(file_path, "r")
	if not file then
		wez.log_info("Failed to open JSON file: " .. file_path)
		return nil
	end

	local file_content = file:read("*a")
	file:close()

	local data = wez.json_parse(file_content)
	if not data then
		wez.log_info("Failed to parse JSON data from file: " .. file_path)
	end
	return data
end


-- Construct the file path based on the session id
local function get_session_state_path()
	if platform.is_win then
		return wez.home_dir .. "/AppData/Local/wezterm/session-manager/session_state_" .. mux.get_domain():name() .. ".json"
	else
		return wez.home_dir .. "/.local/share/wezterm/session-manager/session_state_"  .. mux.get_domain():name() .. ".json"
	end
end


--- Retrieves the current session data from the active domain.
-- @return table or nil: The session data table or nil if no active domain is found.
local function retrieve_session_data()
	local domain      = mux.get_domain()
	local domain_data = {
		id        = tostring(domain:domain_id()),
		name      = domain:name(),
		windows   = {},
	}

	for _, window in ipairs(mux.all_windows()) do
		local window_data = {
			id        = tostring(window:window_id()),
			workspace = window:get_workspace(),
			title     = window:get_title(),
			tabs      = {},
		}

		for _, tab in ipairs(window:tabs()) do
			local tab_data = {
				id     = tostring(tab:tab_id()),
				title  = tab:get_title(),
				panes  = {},
			}

			for _, pane_info in ipairs(tab:panes_with_info()) do
				local pane      = pane_info.pane
				local pane_data = {
					id      = tostring(pane:pane_id()),
					title   = pane:get_title(),
					index   = pane_info.index,
					is_active    = pane_info.is_active,
					is_zoomed    = pane_info.is_zoomed,
					left    = pane_info.left,
					top     = pane_info.top,
					width   = pane_info.width,
					height  = pane_info.heigth,
					pixel_width  = pane_info.pixel_width,
					pixel_height = pane_info.pixel_height,
					cwd     = tostring(pane:get_current_working_dir()),
				}

				table.insert(tab_data.panes, pane_data)
			end

			table.insert(window_data.tabs, tab_data)
		end

		table.insert(domain_data.windows, window_data)
	end

	return domain_data
end


--- Recreates the session based on the provided data.
-- @param data table: The data structure containing the saved session state.
local function recreate_session(_, domain_data)
	local function extract_path_from_dir(dir)
		if platform.is_mac then
			-- On Windows, transform "file:///C:/path/to/dir" to "C:/path/to/dir"
			return dir:gsub("file:///", "")
		elseif platform.is_linux then
			-- On Linux, transform "file://{computer-name}/home/{user}/path/to/dir" to "/home/{user}/path/to/dir"
			return dir:gsub("^.*(/home/)", "/home/")
		else
			return dir:gsub("^.*(/Users/)", "/Users/")
		end
	end

	if not domain_data or not domain_data.windows then
		wez.log_info("Invalid or empty session data provided.")
		return
	end

	local windows = mux.all_windows()
	if #windows ~= 1 or #windows[1]:tabs() ~= 1 or #windows[1]:tabs()[1]:panes() ~= 1 then
		wez.log_info("Restoration can only be performed in a window with a single tab and a single pane, to prevent accidental data loss.")
		return
	end

	local initial_pane = windows[1]:active_pane()
	local foreground_process = initial_pane:get_foreground_process_name()
	-- Check if the foreground process is a shell
	if nil ~= foreground_process then
		if foreground_process:find("sh") or foreground_process:find("cmd.exe") or foreground_process:find("powershell.exe")
				or foreground_process:find("pwsh.exe") or foreground_process:find("nu") then
			-- Safe to close
			initial_pane:send_text("exit\r")
		else
			wez.log_info("Active program detected. Skipping exit command for initial pane.")
		end
	end

	-- Recreate domain, windows, tabs and panes from the saved state
	for _, window_data in ipairs(domain_data.windows) do
		local screens = wez.gui.screens()
		local new_tab, new_pane, new_window = mux.spawn_window({
			domain   = { DomainName = domain_data.name },
			position = {
				x = screens.active.x,
				y = screens.active.y,
				origin = { Named = screens.active.name }
			},
			cwd      = extract_path_from_dir(window_data.tabs[1].panes[1].cwd),
		})
		if not new_window or not new_pane or not new_tab then
			wez.log_info("Failed to create a new window of domain(" .. domain_data.name .. ")")
			break
		end
		new_window:gui_window():maximize()
		new_window:set_workspace(window_data.workspace)
		new_window:set_title(window_data.title)

		for i, tab_data in ipairs(window_data.tabs) do
			if i ~= 1 then
				new_tab = new_window:spawn_tab({ cwd = extract_path_from_dir(tab_data.panes[1].cwd) })
				if not new_tab then
					wez.log_info("Failed to create a new tab.")
					break
				end
			end

			-- Activate the new tab before creating panes
			new_tab:activate()

			-- Recreate panes within this tab
			for j, pane_data in ipairs(tab_data.panes) do
				if j == 1 then
					new_pane = new_tab:active_pane()
				else
					local direction = "Right"
					if pane_data.left == tab_data.panes[j - 1].left then
						direction = "Bottom"
					end

					new_pane = new_tab:active_pane():split({
						direction = direction,
						cwd       = extract_path_from_dir(pane_data.cwd),
					})
				end

				if not new_pane then
					wez.log_info("Failed to create a new pane.")
					break
				end
			end
		end
	end

	wez.log_info("Workspace recreated with new tabs and panes based on saved state.")
	return true
end


--- Orchestrator function to save the current session state.
-- Collects session data, saves it to a JSON file, and displays a notification.
local function save_session(window)
	local data = retrieve_session_data()
	local path = get_session_state_path()

	-- Save the session data to a JSON file and display the appropriate notification
	if save_to_json_file(data, path) then
		window:toast_notification("WezTerm Session Manager", "Session state saved successfully", nil, 4000)
	else
		window:toast_notification("WezTerm Session Manager", "Failed to save session state", nil, 4000)
	end
end


--- Loads the saved json file matching the current session.
local function restore_session(window)
	local path = get_session_state_path()
	local data = load_from_json_file(path)

	if not data then
		window:toast_notification("WezTerm", "Session state file not found", nil, 4000)
		return
	end

	if recreate_session(window, data) then
		window:toast_notification("WezTerm", "Session state loaded", nil, 4000)
	else
		window:toast_notification("WezTerm", "Session state loading failed", nil, 4000)
	end
end


local function make_state_dir()
	local path = get_session_state_path()

	local mkdir = function(dir)
		local cmd
		if platform.is_win then
			cmd = 'if not exist "' .. dir .. '" mkdir "' .. dir .. '"'
		else
			cmd = 'mkdir -p "' .. dir .. '"'
		end
		os.execute(cmd)
	end

	mkdir(path:match("(.*[/])"))
end


M.setup = function()
	wez.on("save_session", function(window)
		save_session(window)
	end)
	wez.on("restore_session", function(window)
		restore_session(window)
	end)

	make_state_dir()
end


return M
