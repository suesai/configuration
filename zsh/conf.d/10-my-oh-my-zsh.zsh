case "$OSTYPE" in
	darwin*)
		export ZSH="${HOME}/.config/oh-my-zsh"
		;;
	linux*)
		export ZSH="/usr/share/oh-my-zsh"
		;;
	*)
		print -u2 "Unsupported operating system: $OSTYPE"
		return 1
		;;
esac

export ZSH_CUSTOM="${ZSH}/custom"
export ZSHZ_DATA="${ZSH_CACHE_DIR}/z"

_zsh_completion_dir="${ZSH_CUSTOM}/plugins/zsh-completions/src"
if [[ -d "$_zsh_completion_dir" ]]; then
	fpath=("$_zsh_completion_dir" $fpath)
fi
unset _zsh_completion_dir

zmodload zsh/complist

# Check for Oh My Zsh updates roughly once a month. Keep the default prompt
# mode so updates remain explicit instead of running silently at startup.
zstyle ':omz:update' frequency 30

# Use the tmux plugin for environment refresh only. Its command aliases are
# disabled because tmux sessions are managed by the configured TPM plugins.
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOREFRESH=true
zstyle ':omz:plugins:tmux' aliases false

plugins=(
	zsh-autosuggestions
	dirhistory
	tmux
	copyfile
	copypath
)

# Keep history suggestions for ordinary commands while avoiding the extra
# asynchronous repaint path on long compound commands and pasted buffers.
typeset -g ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=160

if [[ ! -r "${ZSH}/oh-my-zsh.sh" ]]; then
	print -u2 "Oh My Zsh not found: ${ZSH}/oh-my-zsh.sh"
	return 1
fi

source "${ZSH}/oh-my-zsh.sh"

# dirhistory provides cde, but directory jumps use zoxide.
unalias cde 2>/dev/null

# The tmux plugin is loaded for environment refresh only. Remove its command
# shortcuts; tmux sessions are managed through tmux and TPM.
for _tmux_command in ta tad tds tkss tksv tl to ts tmuxconf tmux _tmux_directory_session; do
	unalias "${_tmux_command}" 2>/dev/null
	unfunction "${_tmux_command}" 2>/dev/null
done

unfunction _zsh_tmux_plugin_run 2>/dev/null

unset _tmux_command
