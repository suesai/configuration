## 安装

- MacOS: `brew install lazygit`
- Linux: 从 github 上下载最新的 lazygit，并解压到 /usr/local/bin/

## 配置

- global:
  - `mkdir $(dirname $LG_CONFIG_FILE)`
  - `cp ./config.yml $LG_CONFIG_FILE`
- local:
  - MacOS: `mkdir ~/Library/Application Support/lazygit/ && cp ./config.yml ~/Library/Application Support/lazygit/`
  - Linux: `mkdir ~/.config/lazygit/ && cp ./config.yml ~/.config/lazygit/`
- 配色采用的是 catppuccin mocha green
