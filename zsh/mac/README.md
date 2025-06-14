## 安装

- MacOS: 自带

## 配置

1. `ZDOTDIR=${HOME}/.config/zsh ZSH=${HOME}/.config/oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`，安装后注意查看 ZDOTDIR 下的文件
2. `git clone https://github.com/zsh-users/zsh-completions.git         ~/.config/oh-my-zsh/custom/plugins/zsh-completions`
3. `git clone https://github.com/zsh-users/zsh-autosuggestions.git     ~/.config/oh-my-zsh/custom/plugins/zsh-autosuggestions`
4. `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting`
5. `cp ./ss.zsh-theme   ~/.config/oh-my-zsh/custom/themes/`
6. `mkdir -p ~/.config/zsh ~/.cache/zsh`
7. `cp ./completion.zsh ~/.config/zsh/`
8. `cp ./zshenv         ~/.zshenv`
9. `cp ./zshrc          ~/.config/zsh/.zshrc`

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
