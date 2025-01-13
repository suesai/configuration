1. 下载插件
	```bash
	git clone https://github.com/zsh-users/zsh-completions.git         ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-autosuggestions.git     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	```
2. 创建 $HOME/.config/zsh/completion.zsh
3. prompt 配色，创建 ~/.oh-my-zsh/custom/themes/ss.zsh-theme
4. 修改 .zshrc
5. 依赖
	· compiledb
	· eza
	· fd
	· fzf, fzf-preview.sh, fzf-tmux
	· lazygit
	· rg
	· tmux
	· tree-sitter
	· bat
