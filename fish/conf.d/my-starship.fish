switch (uname -s)
	case Linux
		set -gx STARSHIP_CONFIG          /etc/starship.toml
end

starship init fish | source

# functions -q fish_prompt; and functions -c fish_prompt _old_fish_prompt
# functions -q fish_right_prompt; and functions -c fish_right_prompt _old_fish_right_prompt

# function fish_prompt
# 	_old_fish_prompt
# 	set -e CMD_DURATION
# end

# function fish_right_prompt
# 	_old_fish_right_prompt
# 	set -e CMD_DURATION
# end
