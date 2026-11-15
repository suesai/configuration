# editor
export EDITOR="nvim"

# language
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# man
export MANPAGER="sh -c 'col -bx | bat -l man --style=plain --paging=always'"
export MANROFFOPT="-c"

# codex
export CODEX_HOME="${HOME}/.config/codex"

# go
export GOPATH="${HOME}/project/go"
export GOPROXY="https://goproxy.tuna.tsinghua.edu.cn,https://goproxy.cn,direct"

# nvm
export NODE_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"
export NODE_REPL_HISTORY="${HOME}/.cache/node/node_repl_history"
export NVM_NODEJS_ORG_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"

# rust
export RUSTUP_DIST_SERVER="https://mirrors.tuna.tsinghua.edu.cn/rustup"
export RUSTUP_UPDATE_ROOT="https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup"

case "$OSTYPE" in
	darwin*)
		export CARGO_HOME="${HOME}/.local/share/cargo"
		export RUSTUP_HOME="${HOME}/.local/share/rustup"
		export LG_CONFIG_FILE="${HOME}/.config/lazygit/config.yml"
		export YAZI_CONFIG_HOME="${HOME}/.config/yazi"

		path+=("${GOPATH}/bin")
		;;
	linux*)
		export DOCKER_CONFIG="/etc/docker"
		export FISH_HOME="/opt/fish"
		export GOROOT="/opt/go"
		export KITTY_HOME="/opt/kitty"
		export KITTY_CONFIG_DIRECTORY="${KITTY_HOME}/config"
		export NVIM_HOME="/opt/nvim"
		export NVM_DIR="/opt/nvm"
		export CARGO_HOME="/opt/cargo"
		export RUSTUP_HOME="/opt/rustup"
		export LG_CONFIG_FILE="/etc/lazygit/config.yml"
		export STARSHIP_CONFIG="/etc/starship.toml"
		export YAZI_CONFIG_HOME="/etc/yazi"

		export GDBHISTFILE="${HOME}/.local/state/gdb/gdb_history"
		export GNUPGHOME="${HOME}/.config/gnupg"
		export LESSHISTFILE="${HOME}/.local/state/less/lesshst"
		export __GL_SHADER_DISK_CACHE_PATH="${HOME}/.cache/nv"
		export SYSTEMTAP_DIR="${HOME}/.cache/systemtap"

		path+=(
			"${CARGO_HOME}/bin"
			"${FISH_HOME}/bin"
			"${GOROOT}/bin"
			"${GOPATH}/bin"
			"${KITTY_HOME}/bin"
			"${NVIM_HOME}/bin"
		)

		_zsh_man_paths=()
		for _zsh_man_path in \
			"${FISH_HOME}/share/man" \
			"${KITTY_HOME}/share/man" \
			"${NVIM_HOME}/share/man" \
			"${RUSTUP_HOME}"/toolchains/stable-*/share/man(N); do
			[[ -d "$_zsh_man_path" ]] && _zsh_man_paths+=("$_zsh_man_path")
		done

		(( ${#_zsh_man_paths} )) &&
			export MANPATH="${(j.:.)_zsh_man_paths}${MANPATH:+:$MANPATH}"

		unset _zsh_man_paths _zsh_man_path
		;;
esac

typeset -U path
path=("${path[@]}")
export PATH
