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
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\
                        " 设置在状态行显示的信息
set tabstop=8           " Tab键的宽度
set softtabstop=4
set shiftwidth=4        " 统一缩进为4
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