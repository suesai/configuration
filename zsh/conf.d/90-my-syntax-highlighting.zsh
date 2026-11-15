# Load syntax highlighting after every custom ZLE widget. This ordering is
# required by zsh 5.8, where zsh-syntax-highlighting wraps widgets instead of
# using the zle-line-pre-redraw hook available in later zsh versions.
_zsh_syntax_highlighting_file="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [[ -r "$_zsh_syntax_highlighting_file" ]]; then
	source "$_zsh_syntax_highlighting_file"
else
	print -u2 "zsh-syntax-highlighting not found: ${_zsh_syntax_highlighting_file}"
fi

unset _zsh_syntax_highlighting_file
