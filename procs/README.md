## 安装

- MacOS: `brew install procs`
- Linux: 从 github 下载，并拷贝到 /usr/local/bin/

## 配置

- global:
  1. `mkdir /etc/procs/`
  2. `cp ./procs.toml /etc/procs/`
- local:
  - MacOS: `mkdir ~/Library/Preferences/com.github.dalance.procs/ && cp ./procs.toml ~/Library/Preferences/com.github.dalance.procs/config.toml`
  - Linux: `mkdir ~/.config/procs/ && cp ./procs.toml ~/.config/procs/config.toml`
- `procs --gen-completion fish && mv ./procs.fish $FISH_HOME/etc/fish/completions/`
