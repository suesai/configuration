# Zsh implementations of the interactive expansions provided by puffer-fish.
_puffer_set_left_buffer() {
	local left="$1"
	local new_buffer="${left}${RBUFFER}"
	BUFFER="$new_buffer"
	CURSOR=${#left}
}

_puffer_replace_token() {
	local value="$1"
	if [[ "$LBUFFER" =~ '^(.*[[:space:]])?[^[:space:]]*$' ]]; then
		_puffer_set_left_buffer "${match[1]}${value}"
	else
		_puffer_set_left_buffer "${value}"
	fi
}

_puffer_current_token() {
	print -r -- "${LBUFFER##*[[:space:]]}"
}

puffer-dot() {
	local token="$(_puffer_current_token)"
	if [[ "$token" =~ '(^|.*/)\.\.$' ]]; then
		_puffer_set_left_buffer "${LBUFFER}/.."
	else
		_puffer_set_left_buffer "${LBUFFER}."
	fi
}

puffer-bang() {
	emulate -L zsh
	setopt localoptions extendedglob

	if [[ "$(_puffer_current_token)" != "!" ]]; then
		_puffer_set_left_buffer "${LBUFFER}!"
		return
	fi

	local previous="$(fc -ln -1)"
	previous="${previous##[[:space:]]#}"
	_puffer_replace_token "$previous"
}

puffer-star() {
	emulate -L zsh
	setopt localoptions extendedglob

	if [[ "$(_puffer_current_token)" != "!" ]]; then
		_puffer_set_left_buffer "${LBUFFER}*"
		return
	fi

	local previous="$(fc -ln -1)"
	previous="${previous##[[:space:]]#}"
	local -a words=("${(z)previous}")
	words=("${words[@]:1}")
	_puffer_replace_token "${(j: :)words}"
}

puffer-dollar() {
	if [[ "$(_puffer_current_token)" == "!" ]]; then
		_puffer_replace_token ""
		_zle_clear_autosuggestion
		zle history-beginning-search-backward
	else
		_puffer_set_left_buffer "${LBUFFER}$"
	fi
}

zle -N puffer-dot
zle -N puffer-bang
zle -N puffer-star
zle -N puffer-dollar

for _puffer_keymap in emacs viins; do
	bindkey -M "${_puffer_keymap}" '.' puffer-dot
	bindkey -M "${_puffer_keymap}" '!' puffer-bang
	bindkey -M "${_puffer_keymap}" '*' puffer-star
	bindkey -M "${_puffer_keymap}" '$' puffer-dollar
done

unset _puffer_keymap
