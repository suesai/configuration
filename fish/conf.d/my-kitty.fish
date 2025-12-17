switch (uname -s)
	case Linux
		set -gx KITTY_CONFIG_DIRECTORY   $KITTY_HOME/config
end
