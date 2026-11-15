# Completion colour subsystem.
#
# Responsibilities:
#   1. Publish the file-kind palette to zsh/complist.
#   2. Render the current command-line path with the same kind-aware colours.
#   3. Switch the whole syntax palette to indexed colours while zsh owns an
#      active selection region, avoiding the zsh 5.9 RGB/attribute bug.

zstyle ':completion:*:*:*:*:default' list-colors \
	${(s.:.)LS_COLORS} \
	'ma=1;38;5;235;48;5;109' \
	'mh=38;5;109'

typeset -gA _completion_exact_highlight_styles
typeset -gA _completion_palette_highlight_styles
typeset -gA _completion_exact_regexp
typeset -gA _completion_palette_regexp
typeset -gA _completion_palette_colors=(
	7f8285 244
	81a2be 110
	69a9a1 73
	8abeb7 109
	b294bb 139
	b5bd68 143
	cc6666 167
	c47570 174
	d19a66 137
	bd8b52 137
	f0c674 222
	00a6b2 37
	b3a06d 144
	c5c8c6 251
	d1d4d2 252
	969896 246
)
typeset -g _completion_render_mode=exact

_completion_convert_palette_style() {
	local style="$1" color needle replacement
	for color in "${(@k)_completion_palette_colors}"; do
		needle="fg=#${color}"
		replacement="fg=${_completion_palette_colors[$color]}"
		style="${style//${needle}/${replacement}}"
	done
	REPLY="$style"
}

_completion_palette_style() {
	if [[ "$_completion_render_mode" == safe ]]; then
		_completion_convert_palette_style "$1"
	else
		REPLY="$1"
	fi
}

_completion_exact_highlight_styles=(
	"${(@kv)ZSH_HIGHLIGHT_STYLES}"
)
_completion_exact_regexp=(
	"${(@kv)ZSH_HIGHLIGHT_REGEXP}"
)
for _completion_style_key in "${(@k)_completion_exact_highlight_styles}"; do
	_completion_convert_palette_style \
		"${_completion_exact_highlight_styles[$_completion_style_key]}"
	_completion_palette_highlight_styles[$_completion_style_key]="$REPLY"
done
for _completion_style_key in "${(@k)_completion_exact_regexp}"; do
	_completion_convert_palette_style \
		"${_completion_exact_regexp[$_completion_style_key]}"
	_completion_palette_regexp[$_completion_style_key]="$REPLY"
done
unset _completion_style_key

_completion_set_render_mode() {
	local mode="$1"
	[[ "$_completion_render_mode" == "$mode" ]] && return 0

	case "$mode" in
		(safe)
			ZSH_HIGHLIGHT_STYLES=(
				"${(@kv)_completion_palette_highlight_styles}"
			)
			ZSH_HIGHLIGHT_REGEXP=(
				"${(@kv)_completion_palette_regexp}"
			)
			;;
		(exact)
			ZSH_HIGHLIGHT_STYLES=(
				"${(@kv)_completion_exact_highlight_styles}"
			)
			ZSH_HIGHLIGHT_REGEXP=(
				"${(@kv)_completion_exact_regexp}"
			)
			;;
		(*)
			return 1
			;;
	esac

	_completion_render_mode="$mode"
	_ZSH_HIGHLIGHT_PRIOR_BUFFER='__completion_render_mode_changed__'
	_ZSH_HIGHLIGHT_PRIOR_CURSOR=-1
}

_completion_file_color_style() {
	local code="$1" style
	local -a parts=("${(@s:;:)code}")
	local -i red green blue

	if [[ "$parts[1]" == 38 && "$parts[2]" == 2 ]] &&
		(( ${#parts} >= 5 )); then
		red=$parts[3]
		green=$parts[4]
		blue=$parts[5]
		style=$(printf 'fg=#%02x%02x%02x' "$red" "$green" "$blue")
		(( ${parts[(Ie)1]:-0} )) && style="${style},bold"
		(( ${parts[(Ie)4]:-0} )) && style="${style},underline"
	elif [[ "$parts[1]" == 38 && "$parts[2]" == 5 ]] &&
		(( ${#parts} >= 3 )); then
		style="fg=$parts[3]"
	else
		return 1
	fi

	_completion_palette_style "$style"
}

_completion_file_color_key() {
	local target="${1%/}"
	[[ -n "$target" ]] || target=/

	# Most shell tokens are not filesystem paths. Reject them with one lookup
	# instead of running the complete file-kind probe chain for every argument.
	if [[ ! -e "$target" && ! -L "$target" ]]; then
		return 1
	fi

	if [[ -L "$target" && ! -e "$target" ]]; then
		REPLY=or
	elif [[ -L "$target" ]]; then
		REPLY=ln
	elif [[ -d "$target" ]]; then
		REPLY=di
	elif [[ -p "$target" ]]; then
		REPLY=pi
	elif [[ -S "$target" ]]; then
		REPLY=so
	elif [[ -b "$target" ]]; then
		REPLY=bd
	elif [[ -c "$target" ]]; then
		REPLY=cd
	elif [[ -f "$target" && -x "$target" ]]; then
		REPLY=ex
	elif [[ -f "$target" ]]; then
		REPLY=fi
	else
		return 1
	fi
}

_completion_add_color_region() {
	local key="$1"
	local -i region_start="$2" region_end="$3"
	local -i keep_underline="${4:-0}"
	local style

	_completion_file_color_style \
		"${_zsh_tomorrow_night_ls_color_codes[$key]}" || return
	style="$REPLY"
	(( keep_underline )) && style="${style},underline"
	if (( ${zsh_highlight__memo_feature:-0} )); then
		region_highlight+=(
			"$(( region_start - 1 )) $region_end $style, memo=zsh-completion-file-colors"
		)
	else
		region_highlight+=(
			"$(( region_start - 1 )) $region_end $style"
		)
	fi
}

_completion_add_file_color() {
	local raw="$1"
	local -i token_start="$2" token_end="$3"
	local decoded="${(Q)raw}" path prefix key
	local -i i=1 component_start=1 is_glob=0

	# A glob keeps its underline, but components before the first glob
	# metacharacter still need their own file-kind colours.
	[[ "$decoded" == *[\*\?\[]* ]] && is_glob=1

	# Quoted and escaped paths need a decoded-to-raw offset map. The syntax and
	# path layers already handle those correctly, so leave them untouched.
	(( ${#decoded} == ${#raw} )) || return 1

	while (( i <= ${#raw} + 1 )); do
		if (( i == ${#raw} + 1 )) || [[ "${raw[i]}" == '/' ]]; then
			if (( i > component_start )); then
				prefix="${raw[1,i-1]}"
				# Components containing or following a glob metacharacter are
				# resolved by shell globbing, not as literal filesystem paths.
				[[ "$prefix" == *[\*\?\[]* ]] && break
				if [[ "$prefix" == '~' ]]; then
					path="$HOME"
				elif [[ "$prefix" == '~/'* ]]; then
					path="${HOME}/${prefix#\~/}"
				elif [[ "$prefix" == /* ]]; then
					path="$prefix"
				else
					path="${PWD}/${prefix}"
				fi
				if _completion_file_color_key "$path"; then
					key="$REPLY"
					_completion_add_color_region "$key" \
						$(( token_start + component_start - 1 )) \
						$(( token_start + i - 2 )) "$is_glob"
				fi
			fi

			if (( i <= ${#raw} )) && [[ "${raw[i]}" == '/' ]]; then
				# Separators always remain normal path colour, even when the
				# component immediately before or after them is a symlink.
				_completion_add_color_region di \
					$(( token_start + i - 1 )) \
					$(( token_start + i - 1 )) "$is_glob"
				component_start=$(( i + 1 ))
			fi
		fi
		(( i++ ))
	done
}

_completion_menu_recolor() {
	emulate -L zsh
	setopt localoptions extendedglob

	if (( ${zsh_highlight__memo_feature:-0} )); then
		region_highlight=(
			"${(@)region_highlight:#*memo=zsh-completion-file-colors}"
		)
	fi

	local quote='' escaped=0 char raw
	local -i index=1 token_start=1

	while (( index <= ${#BUFFER} )); do
		char="${BUFFER[index]}"
		if (( escaped )); then
			escaped=0
		elif [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
		elif [[ "$char" == "'" && "$quote" != '"' ]]; then
			[[ "$quote" == "'" ]] && quote='' || quote="'"
		elif [[ "$char" == '"' && "$quote" != "'" ]]; then
			[[ "$quote" == '"' ]] && quote='' || quote='"'
		elif [[ -z "$quote" && "$char" == [[:space:]\;\|\&\<\>\(\)] ]]; then
			if (( index > token_start )); then
				raw="${BUFFER[token_start,index-1]}"
				_completion_add_file_color \
					"$raw" "$token_start" $(( index - 1 ))
			fi
			token_start=$(( index + 1 ))
		fi
		(( index++ ))
	done

	if (( index > token_start )); then
		raw="${BUFFER[token_start,index-1]}"
		_completion_add_file_color "$raw" "$token_start" $(( index - 1 ))
	fi
}

_zsh_highlight_highlighter_completion_file_predicate() {
	return 0
}

_zsh_highlight_highlighter_completion_file_paint() {
	_completion_menu_recolor
}

_completion_sync_render_mode() {
	local wanted=exact
	if [[ "$KEYMAP" == menuselect || "$KEYMAP" == listscroll ]] ||
		(( REGION_ACTIVE )); then
		wanted=safe
	fi

	[[ "$_completion_render_mode" == "$wanted" ]] && return 0
	_completion_set_render_mode "$wanted"
	_zsh_highlight
}

_completion_repaint_menu_line() {
	local previous_render_mode="$_completion_render_mode"
	_completion_sync_render_mode
	if (( ${zsh_highlight__memo_feature:-0} )); then
		_completion_menu_recolor
	elif [[ "$_completion_render_mode" == "$previous_render_mode" ]]; then
		# zsh 5.8 cannot remove tagged regions. Rebuild through the canonical
		# pipeline so stale file-kind regions are cleared safely.
		_zsh_highlight
	fi
	echoti civis 2>/dev/null
	zle .redisplay
	echoti civis 2>/dev/null
}
