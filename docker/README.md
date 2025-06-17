## 安装

- MacOS: `brew install docker`
- Linux: 根据清华大学开源软件镜像站的提示进行安装

## 配置

### daemon

- MacOS:
  1. `mkdir ~/.config/docker/`
  2. 将 daemon.json 追加到 ~/.config/docker/daemon.json
- Linux:
  1. `mkdir /etc/docker/`
  2. 将 daemon.json 追加到 /etc/docker/daemon.json
- 通过命令 `docker info` 来查看是否更换成功

### cli

- MacOS:
  1. 将 config.json 追加到 ~/.docker/config.json
- Linux:
  1. `mkdir $(dirname $DOCKER_CONFIG)`
  2. 将 config.json 追加到 $DOCKER_CONFIG/config.json

### container

- 在容器的 ~/.bashrc 配置 http_proxy，https_proxy，no_proxy
- 在启动容器的时候使用命令 `docker run --env-file=env-file`
