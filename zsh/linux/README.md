## 安装

- Linux: `aptitude install zsh`

## 配置

1. `ZDOTDIR=${HOME}/.config/zsh ZSH=/usr/share/oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`，安装后注意查看 ZDOTDIR 下文件
2. `git clone https://github.com/zsh-users/zsh-completions.git         /usr/share/oh-my-zsh/custom/plugins/zsh-completions`
3. `git clone https://github.com/zsh-users/zsh-autosuggestions.git     /usr/share/oh-my-zsh/custom/plugins/zsh-autosuggestions`
4. `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting`
5. `cp ./ss.zsh-theme /usr/share/oh-my-zsh/custom/themes/`
6. `cp ./my_completion.zsh /etc/zsh/`
7. `cp ./my_zshenv    /etc/zsh && echo "\nsource /etc/zsh/my_zshenv" >>/etc/zsh/zshenv`
8. `cp ./my_zshrc     /etc/zsh && echo "\nsource /etc/zsh/my_zshrc"  >>/etc/zsh/zshrc`
9. 参考 linux 的“环境变量”设置

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
