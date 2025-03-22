## 安装

1. 下载 fish.tar.gz，解压后进入目录
2. `aptitude gettext; pip3 install Sphinx; aptitude install python3-sphinx`
3. `mkdir build; cd build`
4. `cmake -DCMAKE_INSTALL_PREFIX=/opt/fish -DBUILD_DOCS=ON -DINSTALL_DOCS=ON -DWITH_GETTEXT=ON ..`
5. `cmake --build .`
6. `cmake --install .`
7. `cp -rf ./functions /opt/fish/etc/fish`
8. `echo /opt/fish/bin/fish >>/etc/shells`


## 插件

- 如果想要将插件安装在 /opt/fish/etc/fish，需要确保环境变量 fisher_path 的值为 /opt/fish/etc/fish
- 具体插件可以查看 [awsm.fish](https://github.com/jorgebucaran/awsm.fish)

1. fisher: `curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher`
2. z: `fisher install jethrokuan/z`
3. fzf.fish: `fisher install PatrickF1/fzf.fish`
4. replay.fish: `fisher install jorgebucaran/replay.fish`
5. autopair.fish: `fisher install jorgebucaran/autopair.fish`
6. puffer-fish: `fisher install nickeb96/puffer-fish`
7. nvm.fish: `fisher install jorgebucaran/nvm.fish`
8. base16-fish-shell: `fisher install FabioAntunes/base16-fish-shell`
9. tide: `fisher install IlanCosman/tide@v6`

### 配置 base16-fish-shell

1. `base16-tomorrow-night`

### 配置 tide

1. `tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Dark --show_time='24-hour format' --classic_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, frame' --prompt_connection=Solid --powerline_right_prompt_frame=Yes --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=No`
2. `set -U tide_context_always_display true`
3. `set -U tide_left_prompt_items vi_mode os pwd git newline character`：vi_mode 用于显示 vi 模式，通过 `fish_vi_key_bindings` 开启；character 用于显示大于 1 的返回值。

### 配置 nvm

1. `set -U nvm_mirror https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/`
2. `set -U nvm_default_version v22.1.0`
3. `set -U nvm_data /opt/nvm/versions/node && cp ~/.local/share/nvm/.index /opt/nvm/versions/node`

### 离线配置

1. `cp -rf $HOME/.config/fish /home/$USER/.config`
2. 修改 /home/$USER/.config/fish/fish_variables 三个全局变量 Z_DATA，Z_DATA_DIR，Z_EXCLUDE


## 配置 xdg

1. `cp ./02-environment.sh /etc/profile.d/`


## 卸载

1. `rm -rf $HOME/.cache/fish $HOME/.config/fish $HOME/.local/share/fish /opt/fish`
