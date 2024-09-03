1. 下载插件

```bash
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

2. 创建 $HOME/.config/zsh/completion.zsh

```bash
  # ____ ___  __  __ ____  _     _____ _____ ___ ___  _   _ 
#  / ___/ _ \|  \/  |  _ \| |   | ____|_   _|_ _/ _ \| \ | |
# | |  | | | | |\/| | |_) | |   |  _|   | |  | | | | |  \| |
# | |__| |_| | |  | |  __/| |___| |___  | |  | | |_| | |\  |
#  \____\___/|_|  |_|_|   |_____|_____| |_| |___\___/|_| \_|
 #

# +---------+
# | General |
# +---------+

# source ./gambit.zsh

# Load more completions
fpath=($DOTFILES/zsh/plugins/zsh-completions/src $fpath)

# Should be called before compinit
zmodload zsh/complist

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# Only work with the Zsh function vman
# See $DOTFILES/zsh/scripts.zsh
compdef vman="man"

# +---------+
# | Options |
# +---------+

# setopt GLOB_COMPLETE      # Show autocompletion menu with globs
# setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# Use cache for commands which use it

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification


zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
```

3. prompt 配色，创建 ~/.oh-my-zsh/custom/themes/ss.zsh-theme

```bash
# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# VCS
YS_VCS_PROMPT_PREFIX1="%F{white} on %f%F{66}"
YS_VCS_PROMPT_PREFIX2="%f%F{white}:%f%F{65}"
YS_VCS_PROMPT_SUFFIX="%f"
YS_VCS_PROMPT_DIRTY=" %F{red}x%f"
YS_VCS_PROMPT_CLEAN=" %F{green}o%f"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# SVN info
local svn_info='$(svn_prompt_info)'
ZSH_THEME_SVN_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}svn${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
        # make sure this is a hg dir
        if [ -d '.hg' ]; then
                echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
                echo -n $(hg branch 2>/dev/null)
                if [[ "$(hg config oh-my-zsh.hide-dirty 2>/dev/null)" != "1" ]]; then
                        if [ -n "$(hg status 2>/dev/null)" ]; then
                                echo -n "$YS_VCS_PROMPT_DIRTY"
                        else
                                echo -n "$YS_VCS_PROMPT_CLEAN"
                        fi
                fi
                echo -n "$YS_VCS_PROMPT_SUFFIX"
        fi
}

# Virtualenv
local venv_info='$(virtenv_prompt)'
YS_THEME_VIRTUALENV_PROMPT_PREFIX=" %F{67}"
YS_THEME_VIRTUALENV_PROMPT_SUFFIX=" %f"
virtenv_prompt() {
        [[ -n "${VIRTUAL_ENV:-}" ]] || return
        echo "${YS_THEME_VIRTUALENV_PROMPT_PREFIX}${VIRTUAL_ENV:t}${YS_THEME_VIRTUALENV_PROMPT_SUFFIX}"
}

local exit_code="%(?,,%F{white}C:%f%F{red}%?%f)"

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % ys @ ys-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
PROMPT="
%F{150}#%f \
%(#,%K{132}%F{black}%n%f%k,%F{132}%n%f) \
%F{white}@%f \
%F{138}%m%f \
%F{white}in%f \
%B%F{blue}%~%f%b\
${hg_info}\
${git_info}\
${svn_info}\
${venv_info}\
 \
%F{white}[%f%F{60}%*%f%F{white}]%f $exit_code
%F{168}$ %f"
```

4. 修改 .zshrc

```bash
ZSH_THEME="ss"

plugins=(git extract z zsh-autosuggestions zsh-syntax-highlighting)

[[ "${TERM}" == "xterm"  ]] && export TERM=xterm-256color

source $HOME/.config/zsh/completion.zsh

bindkey "^[q" push-line-or-edit

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND=
export FZF_ALT_C_COMMAND=
eval "$(fzf --zsh)"

_fzf_compgen_path() {
	fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
	fd --type=d --hidden --exclude .git . "$1"
}

_fzf_complete_alias() {
	_fzf_complete +m -- "$@" < <(
		alias | sed 's/=.*//'
	)
}

_fzf_complete_unalias() {
	_fzf_complete -m -- "$@" < <(
		alias | sed 's/=.*//'
	)
}

_fzf_comprun() {
	local command="$1"
	shift

	case "$command" in
		vim|view|nvim|cat|bat)	fzf --preview 'if [ -f {} ]; then bat -n --color=always --line-range :500 {}; fi' "$@" ;;
		export|unset)	fzf --preview "eval 'echo \${}'" "$@" ;;
		cd|ls)		fzf --preview 'if [ -d {} ]; then eza --tree --color=always --icons=always {} | head -200; fi' "$@" ;;
		ssh)		fzf --preview 'dig {}' "$@" ;;
		*)		fzf "$@" ;;
	esac
}

lsps() {
	local pid=""
	local thread=""
	local args=""

	while [[ $# > 0 ]]; do
		if [[ "$1" == "-t" ]]; then
			thread="1"
		elif [[ "$1" == "-p" ]]; then
			shift
			pid="$1"
		fi
		shift
	done

	if [[ -n "${thread}" ]] && [[ -n "${pid}" ]]; then
		args="-L -o pid,nlwp,lwp,ppid,pgid,euser,etime,time,rss,stat,command -p ${pid}"
	elif [[ -n "${thread}" ]]; then
		args="-eL -o pid,nlwp,lwp,ppid,pgid,euser,etime,time,rss,stat,command"
	elif [[ -n "${pid}" ]]; then
		args="-o pid,nlwp,ppid,pgid,euser,etime,time,rss,stat,command -p ${pid}"
	else
		args="-e -o pid,nlwp,ppid,pgid,euser,etime,time,rss,stat,command"
	fi

	eval ps "${args}"
}

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export BAT_THEME=OneHalfDark
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git" HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git" HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api" HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api" HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/bottles"

alias bat="batcat -p --color=always"
alias ll="eza --color=always --icons=always -ilbSh"
alias l="eza --color=always --icons=always"
alias lt="eza --color=always --icons=always -T"
alias vim=nvim
alias view="nvim -R"
alias proxyhp="export https_proxy=http://127.0.0.1:33210 http_proxy=http://127.0.0.1:33210 all_proxy=socks5://127.0.0.1:33211"
alias unproxyhp="unset https_proxy http_proxy all_proxy"
proxyhp
```
