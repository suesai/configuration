# Disk usage
duf() {
	command duf -output mountpoint,size,used,avail,usage,inodes,inodes_usage,type,filesystem -only local,network,fuse,binds,loops "$@"
}

# History with timestamps
hist() {
	fc -lD -t '[%Y-%m-%d %H:%M:%S]' -1 0 | bat
}

# Lazygit
lg() {
	lazygit "$@"
}

# Locate commands by name
lscmd() {
	local cmd p
	local -a valid_paths
	local -A seen

	if (( $# != 1 )); then
		echo "usage: lscmd cmd" >&2
		return 22
	fi

	cmd="$1"

	for p in "${path[@]}"; do
		[[ -z "$p" ]] && continue
		[[ -n "${seen[$p]:-}" ]] && continue
		seen[$p]=1
		[[ -d "$p" ]] && valid_paths+=("$p")
	done

	(( ${#valid_paths} )) || return 1

	for p in "${valid_paths[@]}"; do
		command fd -HI -L -d 1 -t x -F "$cmd" "$p"
	done
}

# HTTP proxy
proxyhp() {
	export http_proxy="http://127.0.0.1:7897" https_proxy="http://127.0.0.1:7897" ftp_proxy="http://127.0.0.1:7897" no_proxy="127.0.0.1,localhost"
}

unproxyhp() {
	unset http_proxy https_proxy ftp_proxy no_proxy
}

# Tail a log file
tailog() {
	local file="$1"

	if [[ ! -e "${file}" ]]; then
		echo "usage: tailog file" >&2
		return 22
	fi

	tail -F "${file}" | BAT_THEME="base16-256" bat -p -l log
}

# Yazi
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
