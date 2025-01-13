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
