switch (uname -s)
	case Linux
		# xdg
		set -gx XDG_CACHE_HOME           $HOME/.cache
		set -gx XDG_CONFIG_HOME          $HOME/.config
		set -gx XDG_DATA_HOME            $HOME/.local/share
		set -gx XDG_STATE_HOME           $HOME/.local/state

		# gdb
		set -gx GDBHISTFILE              $XDG_STATE_HOME/gdb/gdb_history

		# gnupg
		set -gx GNUPGHOME                $XDG_CONFIG_HOME/gnupg

		# less
		set -gx LESSHISTFILE             $XDG_STATE_HOME/less/lesshst

		# nvidia
		set -gx __GL_SHADER_DISK_CACHE_PATH $XDG_CACHE_HOME/nv

		# systemtap
		set -gx SYSTEMTAP_DIR            $XDG_CACHE_HOME/systemtap
end
