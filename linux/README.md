## 命令

### 工作

- aria2c, you-get
- bandwhich, iftop, iptraf-np
- bat
- bottom, btop
- compiledb
- duf
- dust
- exa, eza
- fd
- fuck
- fzf
- go
- hex-patch, hexyl, hevi
- lazygit
- lua
- nping, gping
- nvm, node
- procs
- pueue
- rg
- rust
- scc
- socat
- testdisk
- tldr
- tree-sitter
- ouch, p7zip, unar
- watchexec
- yazi
- zoxide

### 娱乐

- aafire
- asciiquarium
- cmatrix
- cowsay
- figlet
- lolcat
- toilet

## 环境变量

1. `cp ./01-my-environment.sh /etc/profile.d/`
2. 将 `[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"`，`[ -s "${CARGO_HOME}/env" ] && \. "${CARGO_HOME}/env"` 和 `hash thefuck &>/dev/null && eval "$(thefuck --alias)"` 写入到 /etc/bash.bashrc，同时将 ~/.bashrc 中相同的设置删除
3. `systemctl reboot`

### 环境变量应用规则

- 花括号：在当前 shell 中运行命令
- subshell：管道、命令替换、后台任务；父 shell 能访问的变量，subshell 也能访问，但不能修改；创建和销毁速度快
- childshell：直接执行 bash、执行脚本；只继承父 shell export 出的变量，不能修改；速度相较慢
- 以上三种方式都可以整体重定向标准输入、标准输出和标准错误

- 登录 shell：/etc/profile -> /etc/bash.bashrc，~/.profile -> ~/.bashrc
- 交互 shell：/etc/bash.bashrc，~/.bashrc

- 对于 bash：无论是 ssh 还是图形终端，都是先 /etc/profile -> /etc/bash.bashrc，~/.profile -> ~/.bashrc。
- 对于 zsh/fish：当使用 ssh 连接，不使用 bash 环境变量，而是使用自己的；当使用图形终端，先使用 bash，再使用自己的。都不继承父进程的环境变量，即清空。
- 当已经使用 ssh 或者图形终端登录了，此时使用命令 bash/zsh/fish 启动新的 shell：它们依然按照前两个规则进行，都继承父进程的环境变量（注意区分是登录 shell，还是交互 shell）。
- 注意图形终端不是登录 shell，但是从环境变量的角度和登录 shell 一样。
