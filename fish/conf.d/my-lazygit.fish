switch (uname -s)
	case Linux
		set -gx LG_CONFIG_FILE           /etc/lazygit/config.yml
	case Darwin
		set -gx LG_CONFIG_FILE           ~/.config/lazygit/config.yml
end
