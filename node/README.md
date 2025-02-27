## 安装

1. 确保 NVM_DIR 环境变量存在
2. `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash`，其中 v0.40.1 可以是其他的版本
3. 安装 node，`nvm install 22.1.0`
4. 使用其他版本的 node，`nvm ls; nvm use 22.1.0`

## 全局配置文件

1. `cp ./npmrc ${NVM_DIR}/versions/node/v22.1.0/etc/npmrc`，其中 22.1.0 可以是其他版本

## 卸载

1. 卸载 node，`nvm uninstall 22.1.0`
2. 卸载 nvm，`rm -rf ${NVM_DIR}`
