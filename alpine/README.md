## 制作镜像

`docker build -t alpine-compiler .`

## 运行容器

`docker run -it -v /root/project:/root/project --name compiler alpine-compiler:latest`
