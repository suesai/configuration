## 安装步骤

1. `cp ./tmux.conf /etc/`
2. `mkdir /usr/share/tpm && git clone https://github.com/tmux-plugins/tpm /usr/share/tpm/tpm`
3. `tmux start-server`
4. `tmux run-shell /usr/share/tpm/tpm/bin/install_plugins`
