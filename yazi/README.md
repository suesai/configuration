## 安装

- MacOS:
  1. `brew install yazi`
  2. fish: 安装之后，yazi.fish 会自动安装到 /opt/homebrew/share/fish/vendor_completions.d/
  3. zsh : 安装之后，_yazi     会自动安装到 /opt/homebrew/share/zsh/site-functions/
- Linux:
  1. 从 github 上下载 musl 版本并解压
  2. `mv ya yazi /usr/local/bin/`
  3. fish: `mv completions/yazi.fish   $FISH_HOME/etc/fish/completions/`
  4. zsh : `mv completions/{_yazi,_ya} $ZSH_CUSTOM/plugins/zsh-completions/src/`

## 配置

- MacOS:
  1. `mkdir ~/.config/yazi`
  2. `cp init.lua keymap.toml package.toml theme.toml yazi.toml ~/.config/yazi/`
  3. 有两种方式安装插件：
    1. 直接使用 package.toml 中的版本：`ya pkg install`
    2. 使用最新版本的：`rm -f ~/.config/yazi/package.toml && ya pkg install llanosrocas/yaziline Rolv-Apneseth/starship yazi-rs/plugins:git yazi-rs/plugins:smart-enter h-hg/yamb yazi-rs/plugins:full-border yazi-rs/plugins:smart-paste ndtoan96/ouch yazi-rs/flavors:catppuccin-mocha`
  4. 修改 keymap.toml 中的 y 命令
- Linux:
  1. `mkdir /etc/yazi`
  2. `cp init.lua keymap.toml package.toml theme.toml yazi.toml /etc/yazi/`
  3. 有两种方式安装插件，注意都使用 root 用户执行命令：
    1. 直接使用 package.toml 中的版本：`ya pkg install`
    2. 使用最新版本的：`rm -f /etc/yazi/package.toml && ya pkg install llanosrocas/yaziline Rolv-Apneseth/starship yazi-rs/plugins:git yazi-rs/plugins:smart-enter h-hg/yamb yazi-rs/plugins:full-border yazi-rs/plugins:smart-paste ndtoan96/ouch yazi-rs/flavors:catppuccin-mocha`
  4. 修改 keymap.toml 中的 y 命令（由于一般通过 ssh 连接 root，因此 y 命令的 xclip 没有作用）

## 依赖

1. ouch, p7zip
2. starship
3. zoxide
4. xclip, wl-clipboard (Linux)
