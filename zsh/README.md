## 安装步骤

1. `git clone https://github.com/zsh-users/zsh-completions.git         ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions`
2. `git clone https://github.com/zsh-users/zsh-autosuggestions.git     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
3. `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`
4. `cp ./ss.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/`
5. `cp ./my_completion.zsh /etc/zsh/`
6. `cp ./my_zshenv /etc/zsh && echo "\nsource /etc/zsh/my_zshenv" >>/etc/zsh/zshrc`
7. `cp ./my_zshrc  /etc/zsh && echo "\nsource /etc/zsh/my_zshrc"  >>/etc/zsh/zshrc`
8. `cp ./02-environment.sh /etc/profile.d/`

## 依赖

- compiledb
- eza
- fd
- fzf, fzf-preview.sh, fzf-tmux
- lazygit
- rg
- tmux
- tree-sitter
- bat
