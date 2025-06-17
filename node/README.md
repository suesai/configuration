## 安装

- MacOS:
  1. 确保 NVM_DIR 环境变量存在
  2. `brew install node`
- Linux:
  1. 确保 NVM_DIR 环境变量存在
  2. `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash`，其中 v0.40.1 可以是其他的版本
  3. 安装 node，`nvm install 22.1.0`
  4. 使用其他版本的 node，`nvm ls; nvm use 22.1.0`

## 配置

- MacOS:
  1. `cp ./npmrc /opt/homebrew/etc/npmrc`
- Linux:
  1. `cp ./npmrc ${NVM_DIR}/versions/node/v22.1.0/etc/npmrc`，其中 22.1.0 可以是其他版本
- `mkdir ~/.config/npm/ ~/.cache/npm/ ~/.cache/node/`
- 安装 nvm 之后，会在 ~/.zshrc 添加 source 语句，删除该语句；由于 fish 使用了 nvm 插件，因此无需 source

## 卸载

- MacOS:
  1. `brew uninstall node`
- Linux:
  1. 卸载 node，`nvm uninstall 22.1.0`
  2. 卸载 nvm，`rm -rf ${NVM_DIR}`


## 备注

1. MacOS 不使用 nvm，而是直接安装 node，因为有些包直接依赖 node
