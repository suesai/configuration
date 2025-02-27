## 安装步骤

1. `cp ./tmux.conf /etc/`
2. `mkdir /opt/tpm && git clone https://github.com/tmux-plugins/tpm /opt/tpm/tpm`
3. `tmux start-server`
4. `tmux run-shell /opt/tpm/tpm/bin/install_plugins`
