1. 下载插件
	```bash
	git clone https://github.com/zsh-users/zsh-completions.git         ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-autosuggestions.git     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	```
2. 创建 $HOME/.config/zsh/completion.zsh
3. prompt 配色，创建 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/ss.zsh-theme
4. 将 my_zshenv 拷贝到 /etc/zsh/，并 `echo '\nsource /etc/zsh/my_zshenv' >>/etc/zsh/zshrc`
5. 将 my_zshrc  拷贝到 /etc/zsh/，并 `echo '\nsource /etc/zsh/my_zshrc'  >>/etc/zsh/zshrc`
6. 依赖
	· compiledb
	· eza
	· fd
	· fzf, fzf-preview.sh, fzf-tmux
	· lazygit
	· rg
	· tmux
	· tree-sitter
	· bat
