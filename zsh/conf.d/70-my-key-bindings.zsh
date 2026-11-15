# Toggle the case of the character at or before the cursor.
toggle-case-char() {
	emulate -L zsh
	local char replacement

	if (( CURSOR < ${#BUFFER} )); then
		char="${BUFFER[CURSOR + 1]}"
	elif (( CURSOR > 0 )); then
		char="${BUFFER[CURSOR]}"
	else
		return
	fi

	case "$char" in
		[[:lower:]]) replacement="${(U)char}" ;;
		[[:upper:]]) replacement="${(L)char}" ;;
		*) return ;;
	esac

	if (( CURSOR < ${#BUFFER} )); then
		BUFFER="${BUFFER[1,CURSOR]}${replacement}${BUFFER[CURSOR + 2,-1]}"
		(( CURSOR += ${#replacement} ))
	else
		BUFFER="${BUFFER[1,CURSOR - 1]}${replacement}"
		(( CURSOR += ${#replacement} - 1 ))
	fi
}

zle -N toggle-case-char

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

# Alt+Q edits a multi-line command.
bindkey "^[q" push-line-or-edit

# Ctrl+U kills everything before the cursor.
bindkey "^u" backward-kill-line

# While ZLE owns the terminal, receive Ctrl+C as a key instead of letting the
# terminal driver turn it into SIGINT and leave the current line. The original
# terminal settings are restored before a command runs, so Ctrl+C still
# interrupts foreground programs normally.
autoload -Uz add-zle-hook-widget

typeset -gi _fish_zle_isig_depth=0
typeset -g _fish_zle_saved_tty=''

fish-zle-line-init() {
	if (( _fish_zle_isig_depth == 0 )); then
		_fish_zle_saved_tty="$(stty -g < /dev/tty 2>/dev/null)"
		stty -isig < /dev/tty 2>/dev/null
	fi
	(( _fish_zle_isig_depth++ ))
}

fish-zle-line-finish() {
	(( _fish_zle_isig_depth > 0 )) || return
	(( _fish_zle_isig_depth-- ))
	if (( _fish_zle_isig_depth == 0 )); then
		if [[ -n "$_fish_zle_saved_tty" ]]; then
			stty "$_fish_zle_saved_tty" < /dev/tty 2>/dev/null
		else
			stty isig < /dev/tty 2>/dev/null
		fi
	fi
}

zle -N fish-zle-line-init
zle -N fish-zle-line-finish
add-zle-hook-widget line-init fish-zle-line-init
add-zle-hook-widget line-finish fish-zle-line-finish

# Match fish's Ctrl+C behavior while editing: discard the input and redraw the
# prompt in place without terminating the current line.
fish-clear-commandline() {
	emulate -L zsh

	BUFFER=''
	CURSOR=0
	MARK=0
	POSTDISPLAY=''
	region_highlight=()
	_fish_history_token_active=0
	_lastcomp=()

	zle .redisplay
}

zle -N fish-clear-commandline

for _keybinding_keymap in emacs viins vicmd menuselect listscroll; do
	bindkey -M "$_keybinding_keymap" '^C' fish-clear-commandline
done
unset _keybinding_keymap

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

bindkey "^[l" down-case-word
bindkey "^[t" toggle-case-char

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
