## 配置

- MacOS:
  1. `cp -rf ./wezterm/ ~/.config/`
  2. 将 wezterm.lua 中的 package.path 删除
- Linux:
  1. `cp -rf ./wezterm/ /etc/`
  2. 将 `export WEZTERM_CONFIG_FILE=/etc/wezterm/wezterm.lua` 添加到 /etc/profile.d/wezterm.sh 的首行
