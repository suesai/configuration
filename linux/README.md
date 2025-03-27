# 命令

## 工作

- go
- nvm, node
- rust
- lua
- eza
- compiledb
- fd
- fzf
- lazygit
- rg
- tree-sitter
- bat
- gping
- duf
- dust
- tldr
- fuck
- btop
- yazi

## 娱乐

- cowsay
- lolcat
- figlet
- toilet
- cmatrix
- asciiquarium
- aafire


# 环境变量

1. `cp ./01-my-environment.sh /etc/profile.d/`
2. 将 `[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"`，`[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"` 和 `hash thefuck &>/dev/null && eval "$(thefuck --alias)"` 写入到 /etc/bash.bashrc，同时将 ~/.bashrc 中相同的设置删除
3. `systemctl reboot`

## 环境变量应用规则

对于 bash：无论是 ssh 还是图形终端，都是先 /etc/profile，~/.profile，/etc/bash.bashrc，~/.bashrc。

对于 zsh/fish：当使用 ssh 连接，不使用 bash 环境变量，而是使用自己的；当使用图形终端，先使用 bash，再使用自己的；且不继承父进程的环境变量，即清空。

当已经使用 ssh 或者图形终端登录了，此时使用命令 bash/zsh/fish 启动新的 shell：它们依然按照前两个规则进行，但是继承父进程的环境变量（注意区分是不是登录 shell）。

注意图形终端不是登录 shell，但是从环境变量的角度和登录 shell 一样。
