switch (uname -s)
	case Linux
		set -gx STARSHIP_CONFIG          /etc/starship.toml
end

starship init fish | source
