## 安装

- MacOS:
  1. `brew install zoxide`
- Linux:
  1. `unar zoxide-version-x86_64-unknown-linux-musl.tar.gz`
  2. `cd zoxide-version-x86_64-unknown-linux-musl`
  3. `cp zoxide /usr/local/bin/ && cp man/man1/* /usr/local/share/man/man1/`

## 配置

- MacOS:
  - fish: 安装之后 zoxide.fish 会自动安装在 /opt/homebrew/share/fish/vendor_completions.d/
  - zsh : 安装之后 _zoxide     会自动安装在 /opt/homebrew/share/zsh/site-functions/
- Linux:
  - fish:
    1. 确保 my-zoxide.fish 已经在 $FISH_HOME/etc/fish/conf.d/ 下
    2. `cp completions/zoxide.fish $FISH_HOME/etc/fish/completions.d/`
    3. `zoxide import --from=z $Z_DATA`
  - zsh :
    1. 确保 zshrc 中有 zoxide init 语句
    2. `cp completions/_zoxide $ZSH_CUSTOM/plugins/zsh-completions/src/`
    3. `zoxide import --from=z $ZSHZ_DATA`
