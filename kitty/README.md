## 安装

- MacOS:
  1. `brew install kitty`
- Linux:
  1. 从 github 上下载“Linux amd64 binary bundle”，并解压到 $KITTY_HOME
  2. fish:
    1. `mv ${KITTY_HOME}/lib/kitty/shell-integration/fish/vendor_conf.d/*        $FISH_HOME/etc/fish/conf.d/`
    2. `mv ${KITTY_HOME}/lib/kitty/shell-integration/fish/vendor_completions.d/* $FISH_HOME/etc/fish/completions/`
  3. zsh:
    1. `mv /opt/kitty/lib/kitty/shell-integration/zsh/completions/*      $ZSH_CUSTOM/plugins/zsh-completions/src/`
    2. `mv /opt/kitty/lib/kitty/shell-integration/zsh/kitty-integration  $ZSH_CUSTOM/plugins/zsh-completions/src/`
    3. `echo -e "\nautoload -Uz kitty-integration\nkitty-integration\nunfunction kitty-integration" >>/etc/zsh/my_zshrc`

## 配置

- MacOS:
  1. `mkdir ~/.config/kitty`
  2. `cp ./* ~/.config/kitty`
  3. `cd ~/.config/kitty && ln -sf keyboard-shortcuts.conf keyboard-shortcuts-macos.conf`
- Linux:
  1. `cp ./* $KITTY_HOME/config/`
  2. `cd $KITTY_HOME/config/ && ln -sf keyboard-shortcuts.conf keyboard-shortcuts-linux.conf`
