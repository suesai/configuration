return {
	-- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
	ssh_domains = {
		{
			name = "rlk",
			remote_address = "192.168.0.104",
			-- remote_address = "192.168.0.104:8822",
			username = "root",
			remote_wezterm_path = "/usr/bin/wezterm",
		}
	},

	-- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
	unix_domains = {
		{
			name = "unix"
		}
	},

	-- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
	wsl_domains = {
		{
			name = "WSL:Ubuntu",
			distribution = "Ubuntu",
			username = "kevin",
			default_cwd = "/home/kevin",
			default_prog = { "zsh", "-l" },
		},
	},
}
