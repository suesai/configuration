# Bypass zsh-autosuggestions' redundant full redraw when inserting a space.
#
# This widget is defined before zsh-syntax-highlighting is loaded. On zsh 5.8
# the syntax highlighter's legacy widget wrapping will therefore run
# _zsh_highlight after insertion. On zsh 5.9 the pre-redraw hook handles it.
_fish_insert_space() {
	_zsh_autosuggest_highlight_reset 2>/dev/null
	unset POSTDISPLAY
	zle .self-insert
}

zle -N _fish_insert_space
for _space_keymap in emacs viins; do
	bindkey -M "$_space_keymap" ' ' _fish_insert_space
done
unset _space_keymap
