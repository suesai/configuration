## 安装

- MacOS:
  1. `brew install go`
- Linux:
  1. 确保 GOROOT 和 GOPATH 环境变量存在
  2. 从官网下载 tar.gz 压缩包
  3. 解压到 ${GOROOT}

## 卸载

1. `rm -rf ${GOROOT}`

## 配置

1. 修改 $GOROOT/go.env 中的 GOPROXY 为 "https://goproxy.cn,direct"
