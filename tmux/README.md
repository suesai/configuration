## 安装步骤

1. `cp ./tmux.conf /etc/`
2. `mkdir /opt/tpm && git clone https://github.com/tmux-plugins/tpm /opt/tpm/tpm`
3. 修改 /opt/tpm/tpm/scritps/variables.sh，DEFAULT_TPM_PATH="/opt/tpm/"
4. `tmux start-server`
5. `tmux run-shell /opt/tpm/tpm/bin/install_plugins`
