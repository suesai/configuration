配色可以通过如下命令方便查看，`for ((x=0; x<=255; x++)); do echo -e "${x}:\033[38;5;${x}mcolor\033[000m"; done`

1. 修改命令提示符并添加到 ~/.bashrc

```bash
export PS1="\[\033[01;38;5;210m\]\u\[\033[000m\]@\[\033[01;38;5;36m\]\H\[\033[000m\][\[\033[01;38;5;131m\]\t\[\033[000m\]]\[\033[000m\][\[\033[01;38;5;103m\]\#\[\033[000m\]]: \[\033[01;38;5;12m\]\w \[\033[000m\]\n\$ "
export TERM=xterm-256color
ulimit -c unlimited
sysctl -w kernel.core_pattern=core_%e_%s_%u_%g_%p_%t
```

2. 修改目录配色，修改 /etc/DIR_COLORS.256color

```bash
# 原值 DIR 38;5;27
DIR 01;38;5;12     # directory
```

然后执行并添加到 ~/.bashrc

```bash
eval `dircolors /etc/DIR_COLORS.256color`
```

如果想还原目录配色，则执行

```bash
eval `dircolors /etc/DIR_COLORS`
```

3. 修改 vim 配色。将 Tomorrow-Night-Eighties.vim 放到 /usr/share/vim/vim80/colors 里面，然后修改 ~/.vimrc

```bash
colorscheme Tomorrow-Night " 设置颜色主题
syntax enable           " 语法高亮
filetype on             " 检测文件的类型
set number              " 显示行号
set cursorline          " 用浅色高亮当前行
set t_Co=256
set background=dark
"autocmd InsertLeave * se nocul
"autocmd InsertEnter * se cul
set ruler               " 在编辑过程中，在右下角显示光标位置的状态行
set laststatus=2        " 显示状态栏 (默认值为 1, 无法显示状态栏)
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)
                        " 设置在状态行显示的信息
set tabstop=8           " Tab键的宽度
"set softtabstop=4
"set shiftwidth=4        " 统一缩进为4
set autoindent          " vim使用自动对齐，也就是把当前行的对齐格式应用到下一行(自动缩进)
set cindent             " (cindent是特别针对 C语言语法自动缩进)
set smartindent         " 依据上面的对齐格式，智能的选择对齐方式，对于类似C语言编写上有用
set scrolloff=3         " 光标移动到buffer的顶部和底部时保持3行距离
set incsearch           " 输入搜索内容时就显示搜索结果
set hlsearch            " 搜索时高亮显示被找到的文本
set foldmethod=indent   " 设置缩进折叠
set foldlevel=99        " 设置折叠层数
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
                        " 用空格键来开关折叠
" 自动跳转到上次退出的位置
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif                                        
endif
```

4. ssh 超时

* server：修改 /etc/ssh/sshd_config

```bash
ClientAliveInterval 60
ClientAliveCountMax 10080
UseDNS no
TCPKeepAlive yes
```

* server: 修改 /etc/ssh/ssh_config

```bash
StrictHostKeyChecking no
```

* client：修改 ~/.ssh/config

```bash
ServerAliveInterval 60
ServerAliveCountMax 10080
StrictHostKeyChecking no
```

5. 远程连接服务器

* 修改 windows ~/.ssh 及其属下的文件，用户组为 system，用户为自己，只能有一个用户
* 将 ~/.ssh/id_rsa.pub 内容复制到 linux ~/.ssh/authorized_keys
* 修改 linux 的 ~/.ssh 权限为 700，~/.ssh/* 权限为 600
* 修改 /etc/ssh/sshd_config，PermitRootLogin=yes, StrictModes=no, PubkeyAuthentication=yes, PasswordAuthentication=no
* 修改 Remote-SSH 选项，"remote.SSH.showLoginTerminal": true, "remote.SSH.useLocalServer": false, "remote.SSH.path"

6. zsh

下载 zsh-completions

```bash
git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
```

创建 $HOME/.config/zsh/completion.zsh

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

修改 prompt 配色，创建 ~/.oh-my-zsh/custom/themes/ss.zsh-theme

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

修改 .zshrc

```bash
ZSH_THEME="ss"
plugins=(git extract z zsh-autosuggestions zsh-syntax-highlighting)
[[ "${TERM}" == "xterm"  ]] && export TERM=xterm-256color
source $HOME/.config/zsh/completion.zsh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```
