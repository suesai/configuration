# Zsh implementation of autopair.fish's delimiter behavior.
typeset -ga _autopair_left=('(' '[' '"' "'")
typeset -ga _autopair_right=(')' ']' '"' "'")
typeset -ga _autopair_pairs=('()' '[]' '""' "''")

# zsh-autosuggestions skips `_*` widgets. Buffer-mutating widgets therefore use
# non-underscore names and are wrapped by the plugin once per prompt.
_zle_clear_autosuggestion() {
	unset POSTDISPLAY
	if (( $+functions[_zsh_autosuggest_highlight_reset] )); then
		_zsh_autosuggest_highlight_reset
	fi
}

_zle_refresh_autosuggestion_for_buffer() {
	local target_buffer="$1"
	(( ${+_ZSH_AUTOSUGGEST_DISABLED} || ! $#target_buffer )) && return
	if [[ -n "$ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" ]] &&
		(( $#target_buffer > $ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE )); then
		return
	fi
	(( $+functions[_zsh_autosuggest_fetch_suggestion] )) || return

	local suggestion
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_fetch_suggestion "$target_buffer"
	if [[ -n "$suggestion" ]]; then
		POSTDISPLAY="${suggestion#$target_buffer}"
	else
		unset POSTDISPLAY
	fi
	_zsh_autosuggest_highlight_apply
}

_autopair_insert_text() {
	LBUFFER="${LBUFFER}$1"
}

_autopair_insert_left_text() {
	local left_char="$1" right_char="$2"
	local left="${LBUFFER}${left_char}" right="$RBUFFER"

	# Match fish's editor behavior: a delimiter typed at end of line is paired
	# regardless of the preceding character. Also allow nesting when the next
	# character is already a closing delimiter.
	if [[ -z "$right" || "$right" == [[:space:]]* ]]; then
		right="${right_char}${right}"
	else
		local first="${right[1]}"
		if [[ " ${_autopair_right[*]} " == *" ${first} "* ]]; then
			right="${right_char}${right}"
		fi
	fi

	BUFFER="${left}${right}"
	CURSOR=${#left}
}

_autopair_insert_right_text() {
	local key="$1"
	local left="${LBUFFER}${key}" right="$RBUFFER"
	if [[ "$right" == "${key}"* ]]; then
		right="${right[2,-1]}"
	fi
	BUFFER="${left}${right}"
	CURSOR=${#left}
}

_autopair_insert_same_text() {
	local key="$1" remainder="${LBUFFER}${RBUFFER}"
	local left="$LBUFFER" right="$RBUFFER"
	local count=0
	while [[ "$remainder" == *"${key}"* ]]; do
		remainder="${remainder#*"${key}"}"
		(( count++ ))
	done

	if (( count % 2 != 0 )); then
		left="${left}${key}"
	elif [[ "$right" == "${key}"* ]]; then
		left="${left}${key}"
		right="${right[2,-1]}"
	else
		left="${left}${key}"

		local before_char="${left[-2]}" after_char="${right[1]}"
		local before_ok=false after_ok=false
		if [[ -z "$before_char" || "$before_char" == [[:space:]=:$] ||
			" ${_autopair_left[*]} " == *" ${before_char} "* ]]; then
			before_ok=true
		fi
		if [[ -z "$after_char" || "$after_char" == [[:space:]] || " ${_autopair_right[*]} " == *" ${after_char} "* ]]; then
			after_ok=true
		fi

		if [[ "$before_ok" == true && "$after_ok" == true ]]; then
			right="${key}${right}"
		fi
	fi

	BUFFER="${left}${right}"
	CURSOR=${#left}
}

autopair-open-paren() {
	_autopair_insert_left_text '(' ')'
}

autopair-close-paren() {
	_autopair_insert_right_text ')'
}

autopair-open-bracket() {
	_autopair_insert_left_text '[' ']'
}

autopair-close-bracket() {
	_autopair_insert_right_text ']'
}

autopair-double-quote() {
	_autopair_insert_same_text '"'
}

autopair-single-quote() {
	_autopair_insert_same_text "'"
}

_autopair_backspace() {
	local old_buffer="$BUFFER" old_postdisplay="$POSTDISPLAY"
	local full_suggestion="${old_buffer}${old_postdisplay}"
	local left="$LBUFFER" right="$RBUFFER"
	local pair="${LBUFFER[-1]}${RBUFFER[1]}"
	local new_postdisplay='' keep_suggestion=0

	if (( ${_autopair_pairs[(Ie)$pair]:-0} > 0 )); then
		left="${LBUFFER[1,-2]}"
		right="${RBUFFER[2,-1]}"
	elif [[ -n "$left" ]]; then
		left="${LBUFFER[1,-2]}"
	else
		return
	fi

	local new_buffer="${left}${right}"
	local new_cursor=${#left}

	# When deleting from the end of a history suggestion, keep the same full
	# visible text and move one character from BUFFER into POSTDISPLAY. This
	# avoids fetching a new suggestion and avoids an intermediate repaint.
	if (( CURSOR == $#old_buffer )) && [[ -n "$old_postdisplay" &&
		"$full_suggestion" == "$new_buffer"* ]]; then
		new_postdisplay="${full_suggestion#$new_buffer}"
		keep_suggestion=1
	fi

	_zsh_autosuggest_highlight_reset
	BUFFER="$new_buffer"
	CURSOR=$new_cursor
	if (( keep_suggestion )); then
		POSTDISPLAY="$new_postdisplay"
		_zsh_autosuggest_highlight_apply
	else
		_zle_refresh_autosuggestion_for_buffer "$BUFFER"
	fi
}

_autopair_tab() {
	if [[ "$LBUFFER" =~ '\$[^[:space:]]*"$' ]]; then
		LBUFFER="${LBUFFER[1,-2]}"
	fi

	local original_buffer="$BUFFER"
	local attempt="${BUFFER}:${CURSOR}"
	local use_approximate=0
	local force_list=0
	local hide_cursor=1
	local stale_list=0
	local -a saved_completers
	zstyle -a ':completion:*' completer saved_completers

	if [[ -n "${_lastcomp[list]:-}" &&
		"$_completion_last_attempt" != "$attempt" ]]; then
		stale_list=1
	fi

	if (( ${_completion_force_list:-0} )) &&
		[[ "$_completion_force_list_attempt" == "$attempt" ]]; then
		force_list=1
		hide_cursor=0
	fi
	_completion_force_list=0
	_completion_force_list_attempt=''

	if [[ "$_completion_last_attempt" == "$attempt" ]] &&
		(( _completion_last_nmatches == 0 )); then
		use_approximate=1
	fi
	{
		(( hide_cursor )) && echoti civis 2>/dev/null
		if (( stale_list )); then
			zle -R -c
			_lastcomp=()
		fi
		if (( force_list )); then
			zle list-choices
		elif (( use_approximate )); then
			zstyle ':completion:*' completer _approximate
			zle expand-or-complete
		else
			zle expand-or-complete
		fi
	} always {
		zstyle ':completion:*' completer "${saved_completers[@]}"
		if [[ "$KEYMAP" == menuselect || "$KEYMAP" == listscroll ]]; then
			echoti civis 2>/dev/null
		elif (( hide_cursor )); then
			echoti cnorm 2>/dev/null
		fi
	}

	_completion_last_attempt="$attempt"
	_completion_last_nmatches=${_lastcomp[nmatches]:-0}
	if [[ "$BUFFER" != "$original_buffer" ]]; then
		_zle_refresh_autosuggestion_for_buffer "$BUFFER"
	fi
	[[ "$KEYMAP" == menuselect ]] && _completion_repaint_menu_line
}

zle -N autopair-open-paren
zle -N autopair-close-paren
zle -N autopair-open-bracket
zle -N autopair-close-bracket
zle -N autopair-double-quote
zle -N autopair-single-quote
zle -N _autopair_backspace
zle -N _autopair_tab

for _autopair_keymap in emacs viins; do
	bindkey -M "${_autopair_keymap}" '(' autopair-open-paren
	bindkey -M "${_autopair_keymap}" ')' autopair-close-paren
	bindkey -M "${_autopair_keymap}" '[' autopair-open-bracket
	bindkey -M "${_autopair_keymap}" ']' autopair-close-bracket
	bindkey -M "${_autopair_keymap}" '"' autopair-double-quote
	bindkey -M "${_autopair_keymap}" "'" autopair-single-quote
	bindkey -M "${_autopair_keymap}" '^?' _autopair_backspace
	bindkey -M "${_autopair_keymap}" '^H' _autopair_backspace
	bindkey -M "${_autopair_keymap}" '^I' _autopair_tab
done

unset _autopair_keymap
