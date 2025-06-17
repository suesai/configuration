## 安装

- MacOS: `brew install procs`
- Linux: 从 github 下载，并拷贝到 /usr/local/bin/

## 配置

- MacOS:
  1. `mkdir ~/Library/Preferences/com.github.dalance.procs/`
  2. `cp ./procs.toml ~/Library/Preferences/com.github.dalance.procs/config.toml`
  3. 删除掉 Wchan 列
- Linux:
  1. `mkdir /etc/procs/`
  2. `cp ./procs.toml /etc/procs/`
- `procs --gen-completion fish && mv ./procs.fish $FISH_HOME/etc/fish/completions/`
