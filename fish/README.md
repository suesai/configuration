## 安装

- MacOS:
  1. `brew install fish`
- Linux:
  1. 下载 fish.tar.gz，解压后进入目录
  2. `aptitude gettext; pip3 install Sphinx; aptitude install python3-sphinx`
  3. `mkdir build; cd build`
  4. `cmake -DCMAKE_INSTALL_PREFIX=$FISH_HOME -DBUILD_DOCS=ON -DINSTALL_DOCS=ON -DWITH_GETTEXT=ON ..`
  5. `cmake --build .`
  6. `cmake --install .`

## 配置
- MacOS:
  1. `cp -rf ./functions ./conf.d ~/.config/fish`
  2. 确保 /etc/shells 存在 fish 的路径
- Linux:
  1. `cp -rf ./functions ./conf.d $FISH_HOME/etc/fish/`
  2. 确保 /etc/shells 存在 fish 的路径
  3. 参考 linux 的“环境变量”设置

## 插件

- 具体插件可以查看 [awsm.fish](https://github.com/jorgebucaran/awsm.fish)
- MacOS:
  1. fisher: `curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher`
  2. fzf.fish: `fisher install PatrickF1/fzf.fish`
  3. replay.fish: `fisher install jorgebucaran/replay.fish`
  4. autopair.fish: `fisher install jorgebucaran/autopair.fish`
  5. nvm.fish: `fisher install jorgebucaran/nvm.fish`
  6. puffer-fish: `fisher install nickeb96/puffer-fish`
  7. base16-fish-shell: `fisher install FabioAntunes/base16-fish-shell`
- Linux:
  1. 一共安装了 6 个插件：fzf, reply, autopair, nvm, puffer-fish, base16-fish-shell
  2. 前 5 个插件的安装方法：从 github 下载后，解压到 $FISH_HOME/etc/fish 下
  3. base16-fish-shell 的安装方法：从 github 下载解压后，将 functions/{__base16_fish_shell_color_test.fish,__base16_fish_shell_create_vimrc_background.fish,__base16_fish_shell_set_background.fish,__put_template.fish,__put_template_custom.fish,__put_template_var.fish,base16-tomorrow-night.fish} 拷贝到 $FISH_HOME/etc/fish/functions 下

### 配置 nvm

1. `cp ~/.local/share/nvm/.index $NVM_DIR/versions/node`

### 配置 autopair

1. 删除 conf.d/autopair.fish 中 autopair_left，autopair_right，autopair_pairs 中的和大括号相关的字符串

## 卸载

1. `rm -rf $HOME/.config/fish $HOME/.cache/fish $HOME/.local/share/fish $FISH_HOME`
