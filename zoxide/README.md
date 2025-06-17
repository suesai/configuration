## 安装

- MacOS:
  1. `brew install zoxide`
- Linux:
  1. `unar zoxide-version-x86_64-unknown-linux-musl.tar.gz`
  2. `cd zoxide-version-x86_64-unknown-linux-musl`
  3. `cp zoxide /usr/local/bin/ && cp man/man1/* /usr/local/share/man/man1/ && cp completions/zoxide.fish $FISH_HOME/etc/fish/completions.d/`

## 配置

1. fish: 确保 my-zoxide.fish 已经在 $FISH_HOME/etc/fish/conf.d/ 下
2. zsh: 确保 zshrc 中有 zoxide init 语句
3. `zoxide import --from=z $Z_DATA`
