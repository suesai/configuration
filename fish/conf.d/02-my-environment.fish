# editor
set -gx EDITOR                   nvim

# language
set -gx LC_ALL                   en_US.UTF-8
set -gx LANG                     en_US.UTF-8
set -gx LANGUAGE                 en_US.UTF-8

# man
set -gx MANPAGER                 "sh -c 'col -bx | bat -l man --style plain --paging=always'"
set -gx MANROFFOPT               "-c"
switch (uname -s)
	case Linux
		set -gx MANPATH  ":$FISH_HOME/share/man:$KITTY_HOME/share/man:$NVIM_HOME/share/man:$RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/share/man"
end
