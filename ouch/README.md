## 安装

- MacOS:
  1. `brew install ouch`
  2. fish: 安装之后，ouch.fish 会自动安装到 /opt/homebrew/share/fish/vendor_completions.d/
  3. zsh : 安装之后，_ouch     会自动安装到 /opt/homebrew/share/zsh/site-functions/
- Linux:
  1. 从 github 上下载 musl 版本并解压
  2. `mv ouch /usr/local/bin/`
  3. fish: `mv completions/ouch.fish $FISH_HOME/etc/fish/conf.d/`
  4. zsh : `mv completions/_ouch     $ZSH_CUSTOM/plugins/zsh-completions/src/`
  5. `mv man/* /usr/local/share/man/man1/`
