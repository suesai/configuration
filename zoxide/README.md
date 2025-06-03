## 安装

- MacOS:
  1. `brew install zoxide`
- Linux:
  1. `unar zoxide-version-x86_64-unknown-linux-musl.tar.gz`
  2. `cd zoxide-version-x86_64-unknown-linux-musl`
  3. `cp zoxide /usr/local/bin/ && cp man/man1/* /usr/local/share/man/man1/ && cp completions/zoxide.fish $FISH_HOME/etc/fish/completions.d/`

## 配置

1. 确保 my-zoxide.fish 已经在 $FISH_HOME/etc/fish/conf.d/ 下
2. `zoxide import --from=z $Z_DATA`
