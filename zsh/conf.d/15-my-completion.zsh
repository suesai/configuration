# Completion behavior and presentation.
# Oh My Zsh has already loaded zsh/complist and initialized compinit.

# Include dotfiles in completion.
_comp_options+=(globdots)

# Required by the Tab completion wrapper to hide the hardware cursor while
# zsh/complist is repainting a menu selection.
zmodload zsh/terminfo

# Allow terminal escape sequences and Alt/Ctrl combinations to arrive over
# multiple reads without being split into unrelated keys.
KEYTIMEOUT=30

# Menu-selection navigation. Menu selection itself is configured below.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^[' accept-search

_completion_shift_tab() {
	if [[ "$KEYMAP" != menuselect && "$KEYMAP" != listscroll ]] &&
		[[ -z "${_lastcomp[list]:-}" ]]; then
		return 0
	fi

	{
		echoti civis 2>/dev/null
		zle reverse-menu-complete
	} always {
		if [[ "$KEYMAP" == menuselect || "$KEYMAP" == listscroll ]]; then
			echoti civis 2>/dev/null
		else
			echoti cnorm 2>/dev/null
		fi
	}
}

zle -N _completion_shift_tab
for _completion_keymap in emacs viins vicmd; do
	bindkey -M "$_completion_keymap" '^[[Z' _completion_shift_tab
done
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M listscroll '^[[Z' reverse-menu-complete
if [[ -n "${terminfo[kcbt]}" ]]; then
	for _completion_keymap in emacs viins vicmd; do
		bindkey -M "$_completion_keymap" "${terminfo[kcbt]}" _completion_shift_tab
	done
	bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete
	bindkey -M listscroll "${terminfo[kcbt]}" reverse-menu-complete
fi
unset _completion_keymap

# After the first Tab, a short completion list returns to the main keymap.
# Clear that displayed list without modifying the command line.
typeset -gi _completion_force_list=0
typeset -g _completion_force_list_attempt=''
typeset -g _completion_last_attempt=''
typeset -gi _completion_last_nmatches=0

_dismiss_completion_list() {
	_completion_force_list=1
	_completion_force_list_attempt="${BUFFER}:${CURSOR}"
	_completion_last_attempt=''
	_completion_last_nmatches=0
	{
		echoti civis 2>/dev/null
		zle -R -c
	} always {
		echoti cnorm 2>/dev/null
	}
	_lastcomp=()
}

zle -N _dismiss_completion_list
bindkey -M emacs '^[' _dismiss_completion_list
bindkey -M listscroll '^[' _dismiss_completion_list

# Try exact completion first and approximate completion only when exact
# matching produces no candidates.
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:approximate:::' max-errors 1 numeric
zstyle ':completion:*:approximate-*:::' insert-unambiguous false
zstyle ':completion:*:approximate-*:::' original false

# Accept an existing directory immediately and continue in the next component.
zstyle ':completion:*' accept-exact-dirs true

# Cache expensive completion results.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR}/.zcompcache"

# Enter menu selection on repeated Tab. conf.d/60-my-autopair.zsh hides the
# hardware cursor while this menu is active to prevent it from flashing on
# the selected row during each repaint.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:*:*:default' list-prompt '%F{#969896}%M candidates · %p%f'
zstyle ':completion:*:*:*:*:default' select-prompt '%F{#969896}%M candidates · %p%f'

# Complete options after a leading "-" for cd.
zstyle ':completion:*' complete-options true

# Keep file completion lists spacious. Avoid list-dirs-first: zsh 5.9 applies
# it while rendering packed command options and splits their aliases and
# descriptions across the list.
zstyle ':completion:*' special-dirs false
zstyle ':completion:*' list-separator '  '

for _completion_file_tag in \
	globbed-files all-files directories local-directories path-directories; do
	zstyle ":completion:*:*:*:*:${_completion_file_tag}" list-packed false
	zstyle ":completion:*:*:*:*:${_completion_file_tag}" list-rows-first true
done
unset _completion_file_tag

# Pack equivalent command options, such as "--yes" and "-y", onto one line.
zstyle ':completion:*:*:*:*:options' list-packed true

# Completion messages.
zstyle ':completion:*:*:*:*:corrections' format '%F{#f0c674}≈ approximate matches · distance %e%f'
zstyle ':completion:*:*:*:*:descriptions' format '%B%F{#b3a06d}── %d ──%f%b'
zstyle ':completion:*:*:*:*:messages' format ' %F{#00a6b2}· %d%f'
zstyle -e ':completion:*:*:*:*:warnings' format '
	local word="${PREFIX}${SUFFIX}"
	local shown="${word//\%/%%}"
	case "$word" in
		(/*|./*|../*|.*|~*|*/*)
			reply=(" %F{#cc6666}✗ path not found: ${shown}%f")
			;;
		(*)
			reply=(" %F{#cc6666}✗ no matching candidate: ${shown}%f")
			;;
	esac'
bindkey -M menuselect '^[o' accept-and-hold

# Group completions by tag and put useful command types first.
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# Prefer cd targets over directory-stack and named-directory entries.
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Keep normal matching case-insensitive. Approximate corrections are handled by
# the _approximate completer above.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
