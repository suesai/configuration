## clangd

1. clangd 一共有三种index模式：BackgroundIndex，StaticIndex，RemoteIndex
2. StaticIndex 命令为：`clangd-indexer -extra-arg="-Wno-everything" --executor=all-TUs compile_commands.json >.clangd.idx`

## 编译 old kernel

1. 将 [linux-compile-commands](https://github.com/gniuk/linux-compile-commands) 中的 config 和 compile_commands.json 拷贝到 kernel 目录
2. 执行命令生成 autogeneted：`LANGUAGE=en make V=1 CC=gcc-4.6 ARCH=i386 init`
3. 执行 nvim 生成 .cache
