## 安装

- MacOS:
  1. `brew install yazi`
  2. fish: 安装之后，yazi.fish，ya.fish 会自动安装到 /opt/homebrew/share/fish/vendor_completions.d/
  3. zsh : 安装之后，_yazi，    _ya     会自动安装到 /opt/homebrew/share/zsh/site-functions/
- Linux:
  1. 从 github 上下载 musl 版本并解压
  2. `mv ya yazi /usr/local/bin/`
  3. fish: `mv completions/{yazi.fish,ya.fish}   $FISH_HOME/etc/fish/completions/`
  4. zsh : `mv completions/{_yazi,_ya}           $ZSH_CUSTOM/plugins/zsh-completions/src/`

## 配置

- MacOS:
  1. `mkdir ~/.config/yazi`
  2. `cp init.lua keymap.toml package.toml theme.toml yazi.toml ~/.config/yazi/`
  3. 有两种方式安装插件：
    1. 直接使用 package.toml 中的版本：`ya pkg install`
    2. 使用最新版本的：`rm -rf ~/.config/yazi/{plugins,flavors,package.toml} && ya pkg install boydaihungst/mediainfo dedukun/bookmarks GianniBYoung/rsync llanosrocas/yaziline ndtoan96/ouch Rolv-Apneseth/starship XYenon/clipboard yazi-rs/plugins:full-border yazi-rs/plugins:git yazi-rs/plugins:smart-enter yazi-rs/plugins:smart-paste yazi-rs/flavors:catppuccin-mocha`
- Linux:
  1. `mkdir /etc/yazi`
  2. `cp init.lua keymap.toml package.toml theme.toml yazi.toml /etc/yazi/`
  3. 有两种方式安装插件，注意都使用 root 用户执行命令：
    1. 直接使用 package.toml 中的版本：`ya pkg install`
    2. 使用最新版本的：`rm -rf /etc/yazi/{plugins,flavors,package.toml} && ya pkg install boydaihungst/mediainfo dedukun/bookmarks GianniBYoung/rsync llanosrocas/yaziline ndtoan96/ouch Rolv-Apneseth/starship XYenon/clipboard yazi-rs/plugins:full-border yazi-rs/plugins:git yazi-rs/plugins:smart-enter yazi-rs/plugins:smart-paste yazi-rs/flavors:catppuccin-mocha`

## 依赖

1. ouch, p7zip
2. starship
3. zoxide
4. xclip, wl-clipboard (Linux)
5. ffmpeg, media-info
6. poppler
