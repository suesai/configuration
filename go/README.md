## 安装

- MacOS:
  1. `brew install go`
- Linux:
  1. `mkdir $GOROOT`
  2. 从官网下载 tar.gz 压缩包
  3. 解压到 $GOROOT

## 卸载

- MacOS: `brew uninstall go`
- Linux: `rm -rf $GOROOT`

## 配置

- `mkdir $GOPATH`
- MacOS:
  1. 通过 `go env GOROOT` 查看路径，并修改该路径下的 go.evn 中的 GOPROXY
- Linux:
  1. 修改 $GOROOT/go.env 中的 GOPROXY 为 "https://goproxy.cn,direct"
