## 配置

1. `mkdir ~/.config/tmux/ && cp ./tmux.conf ~/.config/tmux/`
2. `mkdir ~/.config/tmux/plugins/ && git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`
3. `tmux start-server`
4. `tmux run-shell ~/.config/tmux/plugins/tpm/bin/install_plugins`
