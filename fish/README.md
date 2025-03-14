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
7. base16-fish-shell: `fisher install FabioAntunes/base16-fish-shell`
8. tide: `fisher install IlanCosman/tide@v6`

### 配置 base16-fish-shell

1. `base16-tomorrow-night`

### 配置 tide

1. `tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Dark --show_time='24-hour format' --classic_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Solid --powerline_right_prompt_frame=Yes --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=No`
2. `set -U tide_context_always_display true`

### 离线配置

1. `cp -rf $HOME/.config/fish /home/$USER/.config`
2. 修改 /home/$USER/.config/fish/fish_variables 三个全局变量 Z_DATA，Z_DATA_DIR，Z_EXCLUDE


## 卸载

1. `rm -rf $HOME/.cache/fish $HOME/.config/fish $HOME/.local/share/fish /opt/fish`
