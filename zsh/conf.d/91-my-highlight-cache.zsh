# Incremental cache for the syntax-highlighting pipeline.
#
# Reuse the existing highlight graph only for one appended top-level space.
# Every semantic-changing edit and every ambiguous shell state falls back to
# the canonical highlighter implementation loaded by 90-my-syntax-highlighting.

typeset -gi _zsh_highlight_incremental_min_length=120
typeset -gi _zsh_highlight_incremental_hits=0

if (( ! ${+functions[_zsh_highlight]} )); then
	return 0
fi

if (( ! ${+functions[_zsh_highlight__full_rebuild]} )); then
	functions -c _zsh_highlight _zsh_highlight__full_rebuild
fi

_zsh_highlight_trailing_space_reusable() {
	emulate -L zsh
	setopt localoptions extendedglob

	local previous="${_ZSH_HIGHLIGHT_PRIOR_BUFFER-}"
	(( ${#previous} >= _zsh_highlight_incremental_min_length )) || return 1
	[[ "$BUFFER" == "${previous} " ]] || return 1
	(( CURSOR == ${#BUFFER} )) || return 1
	[[ -z "${POSTDISPLAY-}" ]] || return 1
	(( ${REGION_ACTIVE:-0} == 0 )) || return 1
	(( ${YANK_ACTIVE:-0} == 0 && ${SUFFIX_ACTIVE:-0} == 0 )) || return 1
	[[ "$KEYMAP" != (menuselect|listscroll) ]] || return 1
	[[ "${_completion_render_mode:-exact}" == exact ]] || return 1
	if (( ${ISEARCHMATCH_ACTIVE:-0} )); then
		return 1
	fi

	# Multi-line lines and here-documents have context that is intentionally
	# left to the full parser.
	[[ "$previous" != *$'\n'* && "$previous" != *'<<'* ]] || return 1

	integer i=1 length=${#previous}
	local char next
	local -a stack

	while (( i <= length )); do
		char="${previous[i]}"
		next="${previous[i+1]}"

		case "${stack[-1]:-}" in
			("'")
				[[ "$char" == "'" ]] && stack[-1]=()
				(( i++ ))
				continue
				;;
			('`')
				if [[ "$char" == '\' ]]; then
					(( i += 2 ))
					continue
				fi
				[[ "$char" == '`' ]] && stack[-1]=()
				(( i++ ))
				continue
				;;
		esac

		if [[ "$char" == '\' ]]; then
			(( i < length )) || return 1
			(( i += 2 ))
			continue
		fi

		if [[ "${stack[-1]:-}" == '"' && "$char" == '"' ]]; then
			stack[-1]=()
			(( i++ ))
			continue
		fi

		if [[ "$char" == '#' &&
			( $i -eq 1 ||
				"${previous[i-1]}" == [[:space:]\;\|\&\(\)] ) ]]; then
			return 1
		fi

		case "$char" in
			("'"|'"'|'`')
				stack+=("$char")
				;;
			('$')
				if [[ "$next" == '{' ]]; then
					stack+=('}')
					(( i++ ))
				elif [[ "$next" == '(' ]]; then
					if [[ "${previous[i+2]}" == '(' ]]; then
						stack+=('))')
						(( i += 2 ))
					else
						stack+=(')')
						(( i++ ))
					fi
				fi
				;;
			('<'|'>')
				if [[ "$next" == '(' ]]; then
					stack+=(')')
					(( i++ ))
				fi
				;;
			('[')
				if [[ "$next" == '[' ]]; then
					stack+=(']]')
					(( i++ ))
				fi
				;;
			('(')
				if [[ "$next" == '(' ]]; then
					stack+=('))')
					(( i++ ))
				else
					stack+=(')')
				fi
				;;
			('{')
				stack+=('}')
				;;
			(')')
				if [[ "${stack[-1]:-}" == '))' && "$next" == ')' ]]; then
					stack[-1]=()
					(( i++ ))
				elif [[ "${stack[-1]:-}" == ')' ]]; then
					stack[-1]=()
				else
					return 1
				fi
				;;
			(']')
				if [[ "${stack[-1]:-}" == ']]' ]]; then
					stack[-1]=()
					(( i++ ))
				else
					return 1
				fi
				;;
			('}')
				[[ "${stack[-1]:-}" == '}' ]] || return 1
				stack[-1]=()
				;;
		esac

		(( i++ ))
	done

	(( ${#stack} == 0 ))
}

_zsh_highlight() {
	local ret=$?
	if _zsh_highlight_trailing_space_reusable; then
		(( _zsh_highlight_incremental_hits++ ))
		typeset -g _ZSH_HIGHLIGHT_PRIOR_BUFFER="$BUFFER"
		typeset -gi _ZSH_HIGHLIGHT_PRIOR_CURSOR=$CURSOR
		return $ret
	fi
	_zsh_highlight__full_rebuild "$@"
}

# Keep completion render-mode synchronization after the syntax-highlighting
# hook. On zsh 5.8 the hook facility remains usable even though syntax
# highlighting itself uses legacy widget wrapping.
if (( ${+functions[_completion_sync_render_mode]} )); then
	zle -N _completion_sync_render_mode
	autoload -Uz add-zle-hook-widget
	if (( ${+functions[add-zle-hook-widget]} )); then
		add-zle-hook-widget \
			zle-line-pre-redraw _completion_sync_render_mode
	fi
fi

# Keep the history suggestion in its autosuggestion style on every redraw.
# zsh-syntax-highlighting uses a last-writer-wins widget wrapper on zsh 5.8;
# it clears the complete region_highlight array after a custom widget such as
# autopair-backspace has re-applied the suggestion style. The result is visible
# only in the terminal as an unstyled (usually white) POSTDISPLAY.
#
# This hook is the final display-layer invariant. It runs after syntax
# highlighting and completion colour synchronization, repairs only the missing
# POSTDISPLAY region, and never fetches a suggestion or mutates the buffer.
_fish_autosuggest_highlight_sync() {
	emulate -L zsh

	(( $#POSTDISPLAY )) || return 0
	(( ${+ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE} )) || return 0

	local expected_highlight
	expected_highlight="${#BUFFER} $(( ${#BUFFER} + $#POSTDISPLAY )) ${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE}"
	(( ${region_highlight[(Ie)$expected_highlight]:-0} )) && return 0

	# Remove the plugin's stale location before tagging the current location.
	if [[ -n "${_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT-}" ]]; then
		region_highlight=(
			"${(@)region_highlight:#${_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT}}"
		)
	fi
	region_highlight+=("$expected_highlight")
	typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT="$expected_highlight"
}

zle -N _fish_autosuggest_highlight_sync
autoload -Uz add-zle-hook-widget
if (( ${+functions[add-zle-hook-widget]} )); then
	add-zle-hook-widget \
		zle-line-pre-redraw _fish_autosuggest_highlight_sync
fi
