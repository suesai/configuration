## 安装

- MacOS: 自带
- Linux: `apt install zsh`

## 配置

- MacOS:
  1. `ZDOTDIR=${HOME}/.config/zsh ZSH=${HOME}/.config/oh-my-zsh RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`，安装后注意查看 ZDOTDIR 下的文件
  2. `git clone https://github.com/zsh-users/zsh-completions.git         ~/.config/oh-my-zsh/custom/plugins/zsh-completions`
  3. `git clone https://github.com/zsh-users/zsh-autosuggestions.git     ~/.config/oh-my-zsh/custom/plugins/zsh-autosuggestions`
  4. `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting`
  5. `mkdir -p  ~/.config/zsh ~/.cache/zsh`
  6. `cp        ./my_zshenv   ~/.zshenv`
  7. `cp        ./my_zshrc    ~/.config/zsh/.zshrc`
  9. `cp    -rf ./conf.d      ~/.config/zsh/`
- Linux:
  1. `ZDOTDIR=/etc/zsh ZSH=/usr/share/oh-my-zsh RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`，安装后注意查看 ZDOTDIR 下文件
  2. `git clone https://github.com/zsh-users/zsh-completions.git         /usr/share/oh-my-zsh/custom/plugins/zsh-completions`
  3. `git clone https://github.com/zsh-users/zsh-autosuggestions.git     /usr/share/oh-my-zsh/custom/plugins/zsh-autosuggestions`
  4. `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting`
  5. `mkdir -p  ~/.config/zsh ~/.cache/zsh`
  6. `cp        ./my_zshenv   /etc/zsh && echo "\nsource /etc/zsh/my_zshenv" >>/etc/zsh/zshenv`
  7. `cp        ./my_zshrc    /etc/zsh && echo "\nsource /etc/zsh/my_zshrc"  >>/etc/zsh/zshrc`
  8. `cp    -rf ./conf.d      /etc/zsh/`
  9. 参考 linux 的“环境变量”设置

## 依赖

- `bat`
- `duf`
- `eza`
- `fd`
- `fzf`
- `git`
- `lazygit`
- `starship`
- `thefuck`
- `tmux`
- `yazi`
- `zoxide`
