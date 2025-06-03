## 包编译

1. 下载三个包：dsc，debian.tar.xz，orig.tar.xz
2. `dpkg-source -x *.dsc`
3. 进入解压后目录，`bear dpkg-buildpackage -b`
4. 执行完毕后会在 dsc 目录生成 deb
