# fzf.fish compatible defaults.
if (( ! $+FZF_DEFAULT_OPTS && ! $+FZF_DEFAULT_OPTS_FILE )); then
	export FZF_DEFAULT_OPTS='--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
fi

_fzf_current_query() {
	print -r -- "${LBUFFER##*[[:space:]]}"
}

_fzf_strip_ansi() {
	print -r -- "$1" | sed $'s/\x1b\\[[0-9;]*[mK]//g'
}

_fzf_replace_token() {
	emulate -L zsh
	local value="$1"

	if [[ "$LBUFFER" =~ '^(.*[[:space:]])?[^[:space:]]*$' ]]; then
		LBUFFER="${match[1]}${value}"
	else
		LBUFFER="${value}"
	fi
	_zle_clear_autosuggestion
}

_fzf_history_widget() {
	emulate -L zsh
	setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases

	local selected num ret
	selected="$(
		fc -rlD -t '%Y-%m-%d %H:%M:%S' 1 |
			awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
			fzf --no-height --scheme=history \
				--bind='ctrl-r:toggle-sort' \
				--query="$LBUFFER"
	)"
	ret=$?
	if (( ret != 0 )); then
		return 0
	fi

	if [[ -n "$selected" ]]; then
		num="$(awk '{print $1}' <<< "$selected")"
		if [[ "$num" =~ '^[1-9][0-9]*\*?$' ]]; then
			zle vi-fetch-history -n "${num%\*}"
		else
			LBUFFER="$selected"
		fi
	fi

	zle -R
}

_fzf_directory_widget() {
	emulate -L zsh
	setopt localoptions pipefail

	local query selected line ret search_root exclude_pattern
	local -a common_search_excludes search_roots existing_roots selections
	local -a search_excludes fd_exclude_args
	query="$(_fzf_current_query)"

	common_search_excludes=(
		# Version-control metadata.
		.git
		.hg
		.svn
		.bzr
		_darcs

		# Language and package-manager dependencies.
		node_modules
		bower_components
		.cache
		'**/.npm/_cacache'
		'**/.npm/_npx'
		.pnpm-store
		'**/.yarn/cache'
		'**/.yarn/unplugged'
		'**/.bun/install/cache'
		'**/go/pkg/mod'
		'**/.cargo/registry'
		'**/.cargo/git'
		'**/.rustup/toolchains'
		'**/.gradle/caches'
		'**/.gradle/daemon'
		'**/.gradle/wrapper/dists'
		'**/.m2/repository'
		'**/.ivy2/cache'

		# Python environments and test caches.
		.venv
		__pycache__
		.pytest_cache
		.mypy_cache
		.ruff_cache
		.tox
		.nox
		.hypothesis

		# Generated build and frontend outputs.
		.next
		.nuxt
		.svelte-kit
		.turbo
		.parcel-cache
		.vite
		CMakeFiles
		dist
		target
		coverage

		# IDE extensions and user-level application data.
		'**/.vscode/extensions'
		'**/.vscode-server/extensions'
		'**/.cursor/extensions'
		'**/.local/share/Trash'
		'**/.local/share/flatpak'
		'**/.local/share/containers'
		'**/.local/share/docker'
		'**/.local/state'
		'**/.local/share/nvim/lazy'
		'**/.local/share/nvim/mason'
		'**/.local/share/nvim.bak*'
		'**/.local/share/rustup/toolchains'
		'**/.local/share/rustup/downloads'
		'**/.local/share/rustup/tmp'

		# Language managers and virtual environments under XDG data.
		'**/.local/share/mise/installs'
		'**/.local/share/mise/downloads'
		'**/.local/share/fnm/node-versions'
		'**/.local/share/nvm/versions'
		'**/.local/share/nvm/.cache'
		'**/.local/share/uv/python'
		'**/.local/pipx/venvs'
		'**/.local/share/virtualenvs'
		'**/.local/share/pnpm/store'

		# Editor and IDE extensions/runtime data under XDG data.
		'**/.local/share/zed/extensions'
		'**/.local/share/zed/languages'
		'**/.local/share/zed/node_runtime'
		'**/.local/share/code-server/extensions'
		'**/.local/share/JetBrains/Toolbox/apps'
		'**/.local/share/helix/runtime'
		'**/.local/share/emacs/elpa'
		'**/.local/share/emacs/eln-cache'
		'**/.local/share/vim/plugged'
		'**/.local/share/vim/pack'
		'**/.local/share/tmux/plugins'
	)

	case "$OSTYPE" in
		darwin*)
			search_roots=(
				"$HOME"
				/opt/homebrew
				/usr
				/private/etc
				/private/tmp
				/private/var/log
			)
			search_excludes=(
				"${common_search_excludes[@]}"

				# macOS-specific system and application caches.
				.DS_Store
				.Trash
				Library/Caches
				Library/Logs
				Library/Developer/Xcode/DerivedData
				Library/Developer/Xcode/Archives
				Library/Developer/CoreSimulator
			)
			;;
		linux*)
			search_roots=(
				/boot
				/etc
				/home
				/media
				/mnt
				/opt
				/root
				/run/media
				/srv
				/tmp
				/usr
				/var
			)
			search_excludes=(
				"${common_search_excludes[@]}"

				# Linux-specific system caches, VM images, and binary journals.
				cache
				lib/docker
				lib/containerd
				lib/machines
				lib/snapd
				lib/libvirt/images
				lib/systemd/coredump
				log/journal

				# Linux-specific non-development resources installed under /usr.
				lib/locale
				share/backgrounds
				share/doc
				share/fonts
				share/gettext
				share/gtk-doc
				share/help
				share/icons
				share/info
				share/locale
				share/man
				share/pixmaps
				share/themes
			)
			;;
		*)
			search_roots=(/)
			search_excludes=(.git)
			;;
	esac

	for search_root in "${search_roots[@]}"; do
		[[ -d "$search_root" ]] && existing_roots+=("$search_root")
	done

	(( ${#existing_roots} )) || existing_roots=(/)

	for exclude_pattern in "${search_excludes[@]}"; do
		fd_exclude_args+=(--exclude "$exclude_pattern")
	done

	selected="$(
		stdbuf -oL fd --absolute-path --hidden "${fd_exclude_args[@]}" --color=always \
			. "${existing_roots[@]}" 2>/dev/null |
			fzf --no-height --ansi --multi --prompt='Directory> ' \
				--query="$query" \
				--preview='if [ -d {} ]; then eza --tree --color=always --icons=always --level=2 {}; elif [ -f {} ]; then bat --color=always --style=numbers --line-range=:500 {}; fi'
	)"
	ret=$?
	if (( ret != 0 )); then
		return 0
	fi

	while IFS= read -r line; do
		[[ -n "$line" ]] || continue
		selections+=("${(q)$(_fzf_strip_ansi "$line")}")
	done <<< "$selected"

	(( ${#selections} > 0 )) && _fzf_replace_token "${(j: :)selections}"
	zle -R
}

_fzf_git_log_widget() {
	emulate -L zsh
	setopt localoptions pipefail

	if ! command git rev-parse --git-dir >/dev/null 2>&1; then
		zle -M "Not in a git repository."
		return 1
	fi

	local query selected line hash ret
	local -a hashes
	query="$(_fzf_current_query)"

	selected="$(
		command git log --no-show-signature --color=always \
			--format='%C(bold blue)%h%C(reset) - %C(cyan)%ad%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset) [%an]' \
			--date=short |
			fzf --no-height --ansi --multi --scheme=history \
				--prompt='Git Log> ' \
				--preview='git show --color=always --stat --patch {1}' \
				--query="$query"
	)"
	ret=$?
	if (( ret != 0 )); then
		return 0
	fi

	while IFS= read -r line; do
		[[ -n "$line" ]] || continue
		line="$(_fzf_strip_ansi "$line")"
		hash="${line%%[[:space:]]*}"
		[[ -n "$hash" ]] && hashes+=("$(command git rev-parse "$hash")")
	done <<< "$selected"

	(( ${#hashes} > 0 )) && _fzf_replace_token "${(j: :)hashes}"
	zle -R
}

_fzf_git_status_widget() {
	emulate -L zsh
	setopt localoptions pipefail

	if ! command git rev-parse --git-dir >/dev/null 2>&1; then
		zle -M "Not in a git repository."
		return 1
	fi

	local query selected line file_path ret
	local -a paths
	query="$(_fzf_current_query)"

	selected="$(
		command git -c color.status=always status --short |
			fzf --no-height --ansi --multi --prompt='Git Status> ' \
				--query="$query" \
				--nth='2..' \
				--preview='git diff --color=always -- {2..}; git diff --cached --color=always -- {2..}'
	)"
	ret=$?
	if (( ret != 0 )); then
		return 0
	fi

	while IFS= read -r line; do
		[[ -n "$line" ]] || continue
		line="$(_fzf_strip_ansi "$line")"
		if [[ "${line[1]}" == "R" ]]; then
			file_path="${line##* -> }"
		else
			file_path="${line[4,-1]}"
		fi
		[[ -n "$file_path" ]] && paths+=("${(q)file_path}")
	done <<< "$selected"

	(( ${#paths} > 0 )) && _fzf_replace_token "${(j: :)paths}"
	zle -R
}

_fzf_processes_widget() {
	emulate -L zsh
	setopt localoptions pipefail

	local query selected line ret
	local -a pid_values
	query="$(_fzf_current_query)"

	selected="$(
		ps -A -o pid=,command= |
			fzf --no-height --multi --prompt='Processes> ' \
				--query="$query" \
				--preview='ps -o pid,ppid,user,%cpu,rss,start,command -p {1}'
	)"
	ret=$?
	if (( ret != 0 )); then
		return 0
	fi

	while IFS= read -r line; do
		line="${line#"${line%%[![:space:]]*}"}"
		[[ -n "$line" ]] && pid_values+=("${line%%[[:space:]]*}")
	done <<< "$selected"

	(( ${#pid_values} > 0 )) && _fzf_replace_token "${(j: :)pid_values}"
	zle -R
}

_fzf_variables_widget() {
	emulate -L zsh
	setopt localoptions pipefail

	local query token selected name ret
	local -a replacements
	local -a parameter_names=(${(k)parameters})
	parameter_names=("${(@)parameter_names:#history}")

	query="$(_fzf_current_query)"
	token="$query"
	if [[ "$query" == \$* ]]; then
		query="${query#\$}"
	fi

	selected="$(
		print -rl -- "${parameter_names[@]}" |
			fzf --no-height --multi --prompt='Variables> ' \
				--query="$query" \
				--preview='zsh -c '\''typeset -p -- "$1"'\'' _ {1}' \
				--preview-window=wrap
	)"
	ret=$?
	if (( ret != 0 )); then
		return 0
	fi

	for name in ${(f)selected}; do
		[[ -n "$name" ]] || continue
		if [[ "$token" == \$* ]]; then
			replacements+=("\$$name")
		else
			replacements+=("$name")
		fi
	done

	(( ${#replacements} > 0 )) && _fzf_replace_token "${(j: :)replacements}"
	zle -R
}

zle -N _fzf_history_widget
zle -N _fzf_directory_widget
zle -N _fzf_git_log_widget
zle -N _fzf_git_status_widget
zle -N _fzf_processes_widget
zle -N _fzf_variables_widget
