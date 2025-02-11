## 安装步骤

1. 创建目录：`mkdir -p ~/.config/tmux/plugins`
2. 拷贝 tmux.conf：`cp ./tmux.conf ~/.config/tmux/tmux.conf`
3. 安装 tpm：`git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`
4. 启动 server：`tmux start-server`
5. 安装其他插件：`tmux run-shell ~/.config/tmux/plugins/tpm/bin/install_plugins`
