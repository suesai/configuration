# Convert the alphanumeric word at the cursor, or before it when the cursor is
# on whitespace or at the end of the buffer. Word characters match Ctrl+W:
# alphanumeric characters and underscore; punctuation is a boundary.
_fish_case_word() {
	emulate -L zsh
	setopt localoptions no_shwordsplit

	local action="$1"
	local buffer="$BUFFER"
	local current_char segment replacement
	local -i length=${#buffer} cursor=CURSOR start end

	(( length > 0 && cursor >= 0 && cursor <= length )) || return 0

	if (( cursor < length )); then
		current_char="${buffer[cursor + 1]}"
		if [[ "$current_char" == [[:alnum:]_] ]]; then
			start=$(( cursor + 1 ))
			while (( start > 1 )) &&
				[[ "${buffer[start - 1]}" == [[:alnum:]_] ]]; do
				(( start-- ))
			done

			end=$(( cursor + 1 ))
			while (( end < length )) &&
				[[ "${buffer[end + 1]}" == [[:alnum:]_] ]]; do
				(( end++ ))
			done
		elif [[ "$current_char" == [[:space:]] ]]; then
			end=$cursor
			while (( end > 0 )) && [[ "${buffer[end]}" == [[:space:]] ]]; do
				(( end-- ))
			done
			(( end > 0 )) || return 0
			[[ "${buffer[end]}" == [[:alnum:]_] ]] || return 0

			start=$end
			while (( start > 1 )) &&
				[[ "${buffer[start - 1]}" == [[:alnum:]_] ]]; do
				(( start-- ))
			done
		else
			return 0
		fi
	else
		end=$length
		while (( end > 0 )) && [[ "${buffer[end]}" == [[:space:]] ]]; do
			(( end-- ))
		done
		(( end > 0 )) || return 0
		[[ "${buffer[end]}" == [[:alnum:]_] ]] || return 0

		start=$end
		while (( start > 1 )) &&
			[[ "${buffer[start - 1]}" == [[:alnum:]_] ]]; do
			(( start-- ))
		done
	fi

	segment="${buffer[start,end]}"
	case "$action" in
		up) replacement="${(U)segment}" ;;
		down) replacement="${(L)segment}" ;;
		*) return 0 ;;
	esac

	BUFFER="${buffer[1,start - 1]}${replacement}${buffer[end + 1,-1]}"
	if (( end <= cursor )); then
		(( CURSOR += ${#replacement} - ${#segment} ))
	fi
	zle -R
	return 0
}

_fish_up_case_word() {
	_fish_case_word up
}

_fish_down_case_word() {
	_fish_case_word down
}

# Toggle the character at the cursor, or the character immediately before it
# when the cursor is on whitespace or at the end of the buffer.
_fish_toggle_case_char() {
	emulate -L zsh

	local buffer="$BUFFER" char replacement
	local -i length=${#buffer} cursor=CURSOR target

	(( length > 0 && cursor >= 0 && cursor <= length )) || return 0

	if (( cursor < length )); then
		target=$(( cursor + 1 ))
		char="${buffer[target]}"
		if [[ "$char" == [[:space:]] ]]; then
			target=$cursor
			(( target > 0 )) || return 0
			char="${buffer[target]}"
			[[ "$char" != [[:space:]] ]] || return 0
		fi
	elif (( cursor == length )); then
		target=$length
		char="${buffer[target]}"
		[[ "$char" != [[:space:]] ]] || return 0
	else
		return 0
	fi

	case "$char" in
		[[:lower:]]) replacement="${(U)char}" ;;
		[[:upper:]]) replacement="${(L)char}" ;;
		*) return 0 ;;
	esac

	BUFFER="${buffer[1,target - 1]}${replacement}${buffer[target + 1,-1]}"
	if (( target <= cursor )); then
		(( CURSOR += ${#replacement} - ${#char} ))
	fi
	zle -R
	return 0
}

# Exchange the character at the cursor with the previous character. On
# whitespace or at the end, exchange the two characters before the cursor.
_fish_transpose_chars() {
	emulate -L zsh

	local buffer="$BUFFER" left right
	local -i length=${#buffer} cursor=CURSOR left_index right_index

	(( length >= 2 && cursor >= 0 && cursor <= length )) || return 0

	if (( cursor < length )); then
		right_index=$(( cursor + 1 ))
		if [[ "${buffer[right_index]}" == [[:space:]] ]]; then
			right_index=$cursor
		fi
	else
		right_index=$length
	fi
	left_index=$(( right_index - 1 ))

	(( left_index >= 1 && right_index <= length )) || return 0
	left="${buffer[left_index]}"
	right="${buffer[right_index]}"
	[[ "$left" != [[:space:]] && "$right" != [[:space:]] ]] || return 0

	BUFFER="${buffer[1,left_index - 1]}${right}${left}${buffer[right_index + 1,-1]}"
	zle -R
	return 0
}

zle -N _fish_up_case_word
zle -N _fish_down_case_word
zle -N _fish_toggle_case_char
zle -N _fish_transpose_chars

# Match fish's backward-kill-word: alphanumeric runs are words, trailing
# whitespace may include the preceding word, and punctuation is deleted one
# character at a time.
_backward-kill-fish-word() {
	emulate -L zsh
	local old_buffer="$BUFFER" old_postdisplay="$POSTDISPLAY"
	local full_suggestion="${old_buffer}${old_postdisplay}"
	local buffer="$LBUFFER" right="$RBUFFER" char pair
	local -i cursor=${#buffer} start delete_pair=0

	(( cursor )) || return
	char="${buffer[cursor]}"
	pair="${char}${right[1]}"

	if [[ "$pair" == '()' || "$pair" == '[]' || "$pair" == '{}' ||
		"$pair" == '""' || "$pair" == "''" ]]; then
		delete_pair=1
		start=$cursor
	elif [[ "$char" == [[:alnum:]_] ]]; then
		while (( cursor > 0 )) && [[ "${buffer[cursor]}" == [[:alnum:]_] ]]; do
			(( cursor-- ))
		done
		start=$(( cursor + 1 ))
	elif [[ "$char" == [[:space:]] ]]; then
		while (( cursor > 0 )) && [[ "${buffer[cursor]}" == [[:space:]] ]]; do
			(( cursor-- ))
		done

		if (( cursor > 0 )) && [[ "${buffer[cursor]}" == [[:alnum:]_] ]]; then
			while (( cursor > 0 )) && [[ "${buffer[cursor]}" == [[:alnum:]_] ]]; do
				(( cursor-- ))
			done
			start=$(( cursor + 1 ))
		else
			start=$(( cursor + 1 ))
		fi
	else
		# fish deletes only the final punctuation character.
		start=${#buffer}
	fi

	local new_buffer
	if (( delete_pair )); then
		new_buffer="${buffer[1,cursor-1]}${right[2,-1]}"
		CUTBUFFER="$pair"
	else
		new_buffer="${buffer[1,start-1]}${RBUFFER}"
		CUTBUFFER="${buffer[start,-1]}"
	fi
	local new_postdisplay='' keep_suggestion=0
	if (( CURSOR == $#old_buffer )) && [[ -n "$old_postdisplay" &&
		"$full_suggestion" == "$new_buffer"* ]]; then
		new_postdisplay="${full_suggestion#$new_buffer}"
		keep_suggestion=1
	fi

	_zsh_autosuggest_highlight_reset
	BUFFER="$new_buffer"
	CURSOR=$(( start - 1 ))
	MARK=$CURSOR
	if (( keep_suggestion )); then
		POSTDISPLAY="$new_postdisplay"
		_zsh_autosuggest_highlight_apply
	else
		_zle_refresh_autosuggestion_for_buffer "$BUFFER"
	fi
}

zle -N _backward-kill-fish-word

# Alt+E edits the current command in $EDITOR; Alt+P parks (pushes) the current
# line. Keeping those actions separate lets push-line handle temporary side
# commands without unexpectedly entering the external editor. Alt+P is used
# instead of the conventional Alt+Q because Linux kitty reserves Alt+Q.
autoload -Uz edit-command-line
zle -N edit-command-line
for _keybinding_keymap in emacs viins vicmd; do
	bindkey -M "$_keybinding_keymap" '^[e' edit-command-line
	bindkey -M "$_keybinding_keymap" '^[p' push-line
	bindkey -M "$_keybinding_keymap" '^[g' get-line
done
unset _keybinding_keymap

# Ctrl+U kills everything before the cursor.
bindkey "^u" backward-kill-line

# Ctrl+P/Ctrl+N always move through history, even when the current command
# contains multiple lines. `up-line-or-history` and `down-line-or-history`
# would move within the buffer first, which can look like history navigation
# has stopped after editing a recalled multi-line command.
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(up-history down-history)
for _keybinding_keymap in emacs viins; do
	bindkey -M "$_keybinding_keymap" '^P' up-history
	bindkey -M "$_keybinding_keymap" '^N' down-history
done
unset _keybinding_keymap

# Keep Ctrl+C as the terminal's native SIGINT character. This also repairs a
# terminal left with `stty -isig` by an older zsh configuration.
stty isig < /dev/tty 2>/dev/null

# Restore terminal output flow control. Ctrl-S pauses output; Ctrl-Q resumes it.
setopt FLOW_CONTROL
stty ixon 2>/dev/null
bindkey -r '^S'
bindkey -r '^Q'

# Match fish's word-editing keys.
for _keybinding_keymap in emacs viins; do
	bindkey -M "$_keybinding_keymap" "^w" _backward-kill-fish-word
done
unset _keybinding_keymap

for _keybinding_keymap in emacs viins vicmd; do
	bindkey -M "$_keybinding_keymap" '^[u' _fish_up_case_word
	bindkey -M "$_keybinding_keymap" '^[l' _fish_down_case_word
	bindkey -M "$_keybinding_keymap" '^[t' _fish_toggle_case_char
	bindkey -M "$_keybinding_keymap" '^T' _fish_transpose_chars
done
unset _keybinding_keymap

# Cycle backward through the arguments of previous commands, matching fish's
# history-token-search-backward. Unlike insert-last-word, repeated calls first
# visit every argument in the current history entry before moving to the
# previous entry.
zmodload -i zsh/parameter

typeset -gi _fish_history_token_active=0
typeset -gi _fish_history_token_event=0
typeset -gi _fish_history_token_word=0
typeset -gi _fish_history_token_cursor=0
typeset -gi _fish_history_token_base_cursor=0
typeset -g _fish_history_token_snapshot=''
typeset -g _fish_history_token_base_buffer=''
typeset -ga _fish_history_token_events
typeset -ga _fish_history_token_words

fish-history-token-backward() {
	emulate -L zsh

	local token
	local -i continuation=0 found=0

	if (( _fish_history_token_active )) &&
		[[ "$BUFFER" == "$_fish_history_token_snapshot" ]] &&
		(( CURSOR == _fish_history_token_cursor )); then
		continuation=1
	fi

	if (( ! continuation )); then
		# The parameter module exposes history entries newest first and shell
		# parsing keeps quotes and escaped spaces in the source token.
		_fish_history_token_events=("${(@)history}")
		_fish_history_token_event=1
		_fish_history_token_base_buffer="$BUFFER"
		_fish_history_token_base_cursor=$CURSOR
	fi

	if (( continuation )) && (( _fish_history_token_word > 1 )); then
		(( _fish_history_token_word-- ))
		found=1
	elif (( continuation )); then
		(( _fish_history_token_event++ ))
	fi

	if (( ! found )); then
		_fish_history_token_words=()
		while (( _fish_history_token_event <= ${#_fish_history_token_events} )); do
			_fish_history_token_words=(
				${(z)_fish_history_token_events[_fish_history_token_event]}
			)
			if (( ${#_fish_history_token_words} )); then
				_fish_history_token_word=${#_fish_history_token_words}
				found=1
				break
			fi
			(( _fish_history_token_event++ ))
		done
	fi

	if (( ! found )); then
		_fish_history_token_active=0
		return 1
	fi

	token="${_fish_history_token_words[_fish_history_token_word]}"
	BUFFER="${_fish_history_token_base_buffer[1,_fish_history_token_base_cursor]}${token}${_fish_history_token_base_buffer[_fish_history_token_base_cursor + 1,-1]}"
	CURSOR=$(( _fish_history_token_base_cursor + ${#token} ))
	MARK=$CURSOR

	_fish_history_token_active=1
	_fish_history_token_snapshot="$BUFFER"
	_fish_history_token_cursor=$CURSOR
}

zle -N fish-history-token-backward

# On an empty command line, fish's token search key starts the cycle. Keep the
# normal puffer-fish dot behavior whenever another token is already being
# edited, so file names and the `..` path expansion still work.
fish-dot() {
	emulate -L zsh

	if { (( _fish_history_token_active )) &&
		[[ "$BUFFER" == "$_fish_history_token_snapshot" ]] &&
		(( CURSOR == _fish_history_token_cursor )); } ||
		[[ -z "$BUFFER" ]]; then
		zle fish-history-token-backward
	elif (( $+functions[puffer-dot] )); then
		zle puffer-dot
	else
		zle self-insert
	fi
}

zle -N fish-dot

for _keybinding_keymap in emacs viins; do
	bindkey -M "$_keybinding_keymap" '.' fish-dot
	bindkey -M "$_keybinding_keymap" '^[.' fish-history-token-backward
done
unset _keybinding_keymap

# Install the fzf launchers after the other editing bindings. Alt+E is reserved
# for edit-command-line and lowercase Alt+L is intentionally left untouched.
#
#   Alt+J  files/directories     Alt+K  processes
#   Alt+R  git log               Alt+S  git status
#   Alt+I  variables
for _fzf_keymap in emacs viins vicmd; do
	bindkey -M "${_fzf_keymap}" '^R' _fzf_history_widget
	bindkey -M "${_fzf_keymap}" '^[j' _fzf_directory_widget
	bindkey -M "${_fzf_keymap}" '^[r' _fzf_git_log_widget
	bindkey -M "${_fzf_keymap}" '^[k' _fzf_processes_widget
	bindkey -M "${_fzf_keymap}" '^[s' _fzf_git_status_widget
	bindkey -M "${_fzf_keymap}" '^[i' _fzf_variables_widget
done
unset _fzf_keymap
